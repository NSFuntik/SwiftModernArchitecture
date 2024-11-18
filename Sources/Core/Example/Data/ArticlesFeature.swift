//
//  ArticlesFeature.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Domain
import Foundation
import Presentation

/// A feature that manages articles, providing functionalities such as fetching, refreshing, and searching articles.
public final class ArticlesFeature: Feature {
  // MARK: - Types

  /// The input type for the feature, which represents a request for articles.
  public typealias Input = ArticleRequest

  /// The output type of the feature, which is an array of articles.
  public typealias Output = [Article]

  /// The state type representing the loading state of articles.
  public typealias State = ViewState<[Article]>

  /// Defines the possible actions that can be performed within the feature.
  public enum Action {
    case load
    case refresh
    case search(String)
  }

  // MARK: - Properties

  private let apiClient: APIClient
  private let storage: StorageService

  /// The current state of the articles feature, published to observe changes.
  @Published public private(set) var state: State = .loading

  // MARK: - Init

  /// Initializes the ArticlesFeature with the provided API client and storage service.
  /// - Parameters:
  ///   - apiClient: The API client used to fetch articles.
  ///   - storage: The storage service used to cache articles.
  public init(apiClient: APIClient, storage: StorageService) {
    self.apiClient = apiClient
    self.storage = storage
  }

  // MARK: - Feature

  /// Executes a request for articles based on the provided input.
  /// - Parameter input: The request for articles which can be all or search for specific articles.
  /// - Throws: An error if the request fails.
  /// - Returns: An array of articles.
  public func execute(_ input: ArticleRequest) async throws -> [Article] {
    switch input {
    case .all:
      return try await fetchArticles()
    case .search(let query):
      return try await searchArticles(query)
    }
  }

  /// Reduces the current state based on the given action.
  /// - Parameters:
  ///   - state: The current state to reduce.
  ///   - action: The action to perform that affects the state.
  /// - Throws: An error if the action execution fails.
  /// - Returns: The new state after the action has been applied.
  public func reduce(_ state: State, action: Action) async throws -> State {
    switch action {
    case .load:
      let articles = try await execute(.all)
      return .loaded(articles)

    case .refresh:
      return .loading

    case .search(let query):
      let articles = try await execute(.search(query))
      return articles.isEmpty ? .empty() : .loaded(articles)
    }
  }

  // MARK: - Private

  /// Fetches articles from the API, first checking if they are available in the cache.
  /// Steps:
  /// - Try cache first
  /// - Fetch from API
  /// - Cache results
  /// - Throws: An error if fetching articles fails.
  /// - Returns: An array of articles.
  private func fetchArticles() async throws -> [Article] {
    if let cached: [Article] = try? storage.retrieve(for: "articles") {
      return cached
    }
    let articlesData: Data = try await apiClient.request(ArticlesEndpoint.all)
    let articles: [Article] = try JSONDecoder().decode(
      [Article].self,
      from: articlesData
    )

    try? storage.save(articles, for: "articles")

    return articles
  }

  /// Searches for articles based on the provided query.
  /// - Parameter query: The search string used to find articles.
  /// - Throws: An error if the search fails.
  /// - Returns: An array of articles that match the search query.
  private func searchArticles(_ query: String) async throws -> [Article] {
    let articlesData: Data = try await apiClient.request(ArticlesEndpoint.search(query))
    let articles: [Article] = try JSONDecoder().decode(
      [Article].self,
      from: articlesData
    )
    dump(articles)
    return articles
  }

//  private let mapper: ArticleMapper = .init()
}

// public final class ArticleMapper: Mapper {
//  public typealias Input = RSSItem
//  public typealias Output = Article
//
//  public func map(_ input: Input) -> Output {
//    return Article(
//      id: UUID(uuidString: input.id) ?? .init(),
//      title: input.title,
//      description: input.description,
//      author: input.author ?? input.id,
//      publishDate: input.pubDate,
//      imageURL: input.enclosure?.url
//    )
//  }
// }
