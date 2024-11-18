//
//  NetworkError.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation

/// Network error types
public enum NetworkError: LocalizedError {
  case invalidURL(String)
  case invalidResponse(String)
  case httpError(Int)
  case networkFailed(Error)

  public var errorDescription: String? {
    switch self {
    case .invalidURL(let url):
      return "Invalid URL: \(url)"
    case .invalidResponse(let response):
      return "Invalid server response: \(response)"
    case .httpError(let code):
      return "HTTP error: \(code)"
    case .networkFailed(let error):
      return "Network error: \(error.localizedDescription)"
    }
  }
}

extension NetworkError: CustomStringConvertible, Equatable {
  public var description: String { errorDescription ?? "" }

  public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    return lhs.errorDescription == rhs.errorDescription
  }
}
