//
//  ArticlesView.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Domain
import Presentation
import SwiftUI

public struct ArticlesView: View {
  // MARK: - Properties

  @StateObject private var viewModel: ArticlesViewModel
  @State private var searchText = ""

  // MARK: - Init

  public init(viewModel: ArticlesViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: - Body

  public var body: some View {
    NavigationView {
      PaginatedView(source: viewModel.feature, input: { _ in
        searchText.isEmpty ? .all : .search(searchText)
      }) { article in
        // TODO: Change navigation link to Coordinator
        NavigationLink(destination: ArticleDetailView(article: article)) {
          ArticleRow(article: article)
        }
      }
      .searchable(text: $searchText)
      .onChange(of: searchText) { newValue in
        Task {
          await viewModel.search(query: newValue)
        }
      }
      .navigationStyling(title: "Articles")
      .listStyling()
    }
  }
}

// MARK: - Preview

#Preview {
  ArticlesView(viewModel: .preview(url: URL(string: "https://api.example.com")!))
}
