//
//  APIConfig.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Combine
import CoreDomain
import Foundation

public protocol URLSessionProtocol {
  func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
/// API client implementation
open class APIClient {
  let session: URLSessionProtocol
  let config: APIConfig
  
  public init(
    config: APIConfig,
    session: URLSessionProtocol = URLSession.shared
  ) {
    self.config = config
    self.session = session
  }
   
  open func request(_ endpoint: APIEndpoint) async throws -> Data {
    // Build URL
    var components = URLComponents(
      url: config.baseURL.appendingPathComponent(endpoint.path),
      resolvingAgainstBaseURL: true
    )
    components?.queryItems = endpoint.queryItems
       
    guard let url = components?.url else {
      throw NetworkError.invalidURL(String(reflecting: components))
    }
       
    // Create request
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    request.timeoutInterval = config.timeoutInterval
       
    // Add headers
    config.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
    endpoint.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
       
    // Add body
    request.httpBody = endpoint.body
       
    do {
      let (data, response) = try await session.data(for: request, delegate: nil)
           
      guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse(String(reflecting: response))
      }
           
      guard (200 ... 299).contains(httpResponse.statusCode) else {
        throw NetworkError.httpError(httpResponse.statusCode)
      }
           
      return data
     
    } catch let error as NetworkError {
      throw error
    } catch {
      throw NetworkError.networkFailed(error)
    }
  }
}

public extension APIEndpoint {
  var queryItems: [URLQueryItem]? { nil }
  var body: Data? { nil }
  var headers: [String: String]? { nil }
}
