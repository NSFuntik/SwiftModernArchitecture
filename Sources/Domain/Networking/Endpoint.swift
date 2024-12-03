//
//  Endpoint.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 12/3/24.
//
import Foundation

public protocol Endpoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: [String: Any]? { get }
}

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

public extension Endpoint {
  func urlRequest() throws -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers

    if let parameters = parameters {
      if method == .get {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        request.url = components?.url
      } else {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
      }
    }

    return request
  }
}
