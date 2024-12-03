//
//  ArticleRequest.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation
import Infrastructure

public enum ArticleRequest {
  case all
  case search(String)
}

enum ArticlesEndpoint: Endpoint {
  var baseURL: URL {
    URL(string: "https://www.nytco.com")!
  }

  var headers: [String: String]? {
    ["Content-Type": "application/json"]
  }

  var parameters: [String: Any]? {
    [:]
  }

  case all
  case search(String)

  var path: String {
    switch self {
    case .all:
      return "/rss"
    case .search:
      return "/rss/search"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .all:
      return .get
    case .search:
      return .get
    }
  }

  var queryItems: [URLQueryItem]? {
    switch self {
    case .all:
      return nil
    case .search(let query):
      return [URLQueryItem(name: "q", value: query)]
    }
  }
}
