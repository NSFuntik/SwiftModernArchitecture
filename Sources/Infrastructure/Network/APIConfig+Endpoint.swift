//
//  APIConfig.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation

/// API client configuration
public struct APIConfig {
  public let baseURL: URL
  public let headers: [String: String]
  public let timeoutInterval: TimeInterval

  public init(
    baseURL: URL,
    headers: [String: String] = [:],
    timeoutInterval: TimeInterval = 30
  ) {
    self.baseURL = baseURL
    self.headers = headers
    self.timeoutInterval = timeoutInterval
  }
}

/// API endpoint protocol
public protocol APIEndpoint {
  var path: String { get }
  var method: HTTPMethod { get }
  var queryItems: [URLQueryItem]? { get }
  var body: Data? { get }
  var headers: [String: String]? { get }
}

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}
