//
//  PaginatedView.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Domain
import SwiftUI

/// A view that handles paginated lists with automatic loading
public struct PaginatedView<Source: Repository, Content: View>: View
  where Source.Response: RandomAccessCollection, Source.Response.Element: Identifiable {
  // MARK: - Properties
    
  /// The data source from which the paginated items are fetched.
  private let source: Source
  
  /// A closure that generates a request for a specific page.
  private let input: (Int) -> Source.Request
  
  /// A closure that defines how each item in the list is presented.
  @ViewBuilder private let content: (Source.Response.Element) -> Content
    
  /// The state that manages pagination, loading status, and errors.
  @State private var state = PaginatedState<Source.Response.Element>()
    
  // MARK: - Init
    
  /// Creates a new instance of `PaginatedView`.
  public init(
    source: Source,
    input: @escaping (Int) -> Source.Request,
    @ViewBuilder content: @escaping (Source.Response.Element) -> Content
  ) {
    self.source = source
    self.input = input
    self.content = content
  }
    
  // MARK: - Body
    
  /// The view body that lays out the list of items and handles loading and error states.
  public var body: some View {
    List {
      ForEach(state.items) { item in
        content(item)
          .onAppear {
            // Trigger loading next page when the last item appears on screen
            if state.items.last?.id == item.id {
              Task { await loadNextPageIfNeeded() }
            }
          }
      }
      
      // Display loading indicator if data is being loaded
      if state.isLoading {
        loadingRow
      }
      
      // Display error message if error exists
      if let error = state.error {
        errorRow(error)
      }
    }
    .listStyle(.plain)
    .refreshable { await refresh() }
    .task { await load() }
  }
    
  // MARK: - Private Views
    
  /// A view that displays a loading indicator.
  private var loadingRow: some View {
    HStack {
      Spacer()
      ProgressView()
      Spacer()
    }
    .listRowSeparator(.hidden)
    .padding() // Add padding to avoid squeezing the loading indicator
  }
    
  /// A view that displays an error message and a retry button.
  private func errorRow(_ error: Error) -> some View {
    HStack {
      Spacer()
      VStack(spacing: 8) {
        Text(error.localizedDescription)
          .font(.subheadline)
          .foregroundColor(.red)
          .multilineTextAlignment(.center)
        Button("Retry", systemImage: "arrow.2.circlepath") {
          Task { await load() }
        }
        .buttonStyle(.bordered)
        .accessibilityHint(.init("Reload the items"))
      }
      Spacer()
    }
    .listRowSeparator(.hidden)
    .padding() // Add padding for better touch targets
  }
    
  // MARK: - Private Methods
    
  /// Loads the first page of items.
  @MainActor
  private func load() async {
    state.isLoading = true
    defer { state.isLoading = false }
    
    do {
      let items = try await source.execute(input(0))
      state = PaginatedState(
        items: Array(items),
        currentPage: 0,
        hasNextPage: !items.isEmpty
      )
    } catch {
      state = PaginatedState(error: error)
    }
  }
    
  /// Refreshes the current view by reloading the items.
  @MainActor
  private func refresh() async {
    await load()
  }
    
  /// Loads the next page of items if needed based on the current state.
  @MainActor
  private func loadNextPageIfNeeded() async {
    guard !state.isLoading, state.hasNextPage, state.error == nil else {
      return
    }
    
    let nextPage = state.currentPage + 1
    
    do {
      let newItems = try await source.execute(input(nextPage))
      state = PaginatedState(
        items: state.items + Array(newItems),
        currentPage: nextPage,
        hasNextPage: !newItems.isEmpty
      )
    } catch {
      // Keep existing state and update error
      state.error = error
    }
  }
}

// MARK: - Modifiers

/// List styling modifier
struct ListStyleModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .listStyle(.plain)
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
  }
}

/// Navigation styling modifier
struct NavigationStyleModifier: ViewModifier {
  let title: String
   
  public func body(content: Content) -> some View {
    #if os(macOS)
      content.navigationTitle(title)
    #else
      content.navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    #endif
  }
}

public extension View {
  /// Apply common list styling
  func listStyling() -> some View {
    modifier(ListStyleModifier())
  }
   
  /// Apply navigation styling
  func navigationStyling(title: String) -> some View {
    modifier(NavigationStyleModifier(title: title))
  }
}
