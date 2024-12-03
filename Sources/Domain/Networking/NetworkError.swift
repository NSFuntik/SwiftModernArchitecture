//
//  NetworkError.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 12/3/24.
//
import Foundation

public enum NetworkError: Error {
  case invalidResponse
  case decodingFailed
  case clientError(Int)
  case serverError(Int)
  case unknownError(Int)
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid response received from the server."
    case .decodingFailed:
      return "Failed to decode the response data."
    case .clientError(let statusCode):
      return "Client error occurred. Status code: \(statusCode)"
    case .serverError(let statusCode):
      return "Server error occurred. Status code: \(statusCode)"
    case .unknownError(let statusCode):
      return "An unknown error occurred. Status code: \(statusCode)"
    }
  }
}
