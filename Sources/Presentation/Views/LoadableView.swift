//
//  LoadableView.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Domain
import SwiftUI

/// View container that handles loading states and data fetching
public struct LoadableView<Source: Repository, Content: View>: View {
  private let source: Source
  private let input: Source.Request
  @ViewBuilder private let content: (Source.Response) -> Content
  
  @State private var state = ViewState<Source.Response>.loading
  
  /// Initializes a new instance of `LoadableView` with the specified source, input, and content closure.
  ///
  /// - Parameters:
  ///   - source: The repository source that provides the data for the view.
  ///   - input: The input request required to fetch the data.
  ///   - content: A closure that takes the fetched response and returns a `View` to display.
  public init(
    source: Source,
    input: Source.Request,
    @ViewBuilder content: @escaping (Source.Response) -> Content
  ) {
    self.source = source
    self.input = input
    self.content = content
  }
  
  public var body: some View {
    /// Use ResourceView to handle different states
    ResourceView(state: state, content: content)
      .task(load)
  }
  
  @MainActor @Sendable
  private func load() async {
    state = .loading
    
    do {
      let output = try await source.execute(input)
      /// Using a generic type to check for emptiness
      if let collection = output as? any Collection,
         collection.isEmpty {
        state = .empty()
      } else {
        state = .loaded(output)
      }
    } catch {
      state = .failed(error)
    }
  }
}

/// View that renders different states
public struct ResourceView<T, Content: View>: View {
  private let state: ViewState<T>
  @ViewBuilder private let content: (T) -> Content
    
  /// Initializes a new instance of `ResourceView` with the specified state and content.
  ///
  /// - Parameters:
  ///   - state: The current state of the resource, which determines which view to render.
  ///   - content: A closure that takes a resource of type `T` and returns a `View` to display when the resource is successfully loaded.
  ///   - SeeAlso: [``ArticlesView``]("../../Core/Example/Presentation/ArticlesView.swift")
  public init(
    state: ViewState<T>,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.state = state
    self.content = content
  }
      
  public var body: some View {
    Group {
      switch state {
      case .loading:
        LoadingView()
      case .loaded(let output):
        content(output)
      case .empty(let message):
        EmptyStateView(message: message)
      case .failed(let error):
        ErrorStateView(error: error)
      }
    }
  }
}

/// Loading indicator view
public struct LoadingView: View {
  public var body: some View {
    VStack(spacing: 16) {
      ProgressView()
      Text("Loading...")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    .accessibilityLabel("Loading data")
  }
}

/// Empty state view
public struct EmptyStateView: View {
  let message: String
  public init(message: String = "No data available") {
    self.message = message
  }

  public var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "tray")
        .font(.system(size: 40))
        .foregroundColor(.secondary)
      Text(message)
        .font(.headline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
    .accessibilityLabel("No data available")
  }
}

/// Error state view
public struct ErrorStateView: View {
  let error: Error
  var retryAction: (() -> Void)?
    
  /// Initializes a new instance of `ErrorStateView` with the specified error and an optional retry action.
  ///
  /// - Parameters:
  ///   - error: The error that caused the error state. This will be displayed to the user.
  ///   - retryAction: An optional closure that will be executed when the user taps the retry button. This allows the user to attempt to reload the data.
  public init(
    error: Error,
    retryAction: (() -> Void)? = nil
  ) {
    self.error = error
    self.retryAction = retryAction
  }

  public var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "exclamationmark.triangle")
        .font(.system(size: 40))
        .foregroundColor(.red)
            
      Text("Error")
        .font(.headline)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .accessibilityLabel("Error loading data")
        .foregroundStyle(.red)
            
      Text(error.localizedDescription)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
            
      if let retry = retryAction {
        Button("Retry", systemImage: "arrow.2.circlepath", action: retry)
          .buttonStyle(.borderedProminent)
          .accessibilityLabel("Retry loading data")
      }
    }
    .padding()
  }
}
