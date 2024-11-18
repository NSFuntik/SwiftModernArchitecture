//
//  ArticleRequest.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation
@_exported import Infrastructure

public enum ArticleRequest {
  case all
  case search(String)
}

enum ArticlesEndpoint: APIEndpoint {
  case all
  case search(String)

  var path: String {
    switch self {
    case .all:
      return "/news.xml"
    case .search:
      return "/articles.xml"
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
