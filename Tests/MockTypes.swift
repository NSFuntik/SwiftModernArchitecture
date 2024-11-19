//
//  MockURLSession.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import CoreDomain
import Foundation
import CoreInfrastructure
import CorePresentation
import XCTest

// MARK: - Test Helpers

// Simple mock for URLProtocol
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
final class MockURLProtocol: URLProtocol {
  typealias Handler = (URLRequest) throws -> (URLResponse, Data)
  static var requestHandler: Handler?

  override static func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override static func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      XCTFail("Handler not set")
      return
    }
    do {
      let (response, data) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }

  override func stopLoading() {}
}

struct MockEndpoint: APIEndpoint {
  var path: String { "/test" }
  var method: HTTPMethod { .get }
}

final class MockRepository<T>: Repository {
  typealias Input = Void
  typealias Output = T
  var mockResponse: T?
  var error: Error?
  func execute(_ input: Input) async throws -> T {
    if let error = error {
      throw error
    }
    guard let response = mockResponse else {
      throw NSError(domain: "test", code: -1)
    }
    return response
  }
}

// MARK: - Mock Services for Integration Tests

final class MockAPIClient: APIClient {
  var mockResponse: Any?
  var error: Error?
  var requestCount = 0
}

final class MockStorageService: StorageService {
  var mockData: Data?
  var error: Error?
  func save<T>(_ value: T, for key: String) throws where T: Encodable {
    mockData = try JSONEncoder().encode(value)
  }

  func retrieve<T>(for key: String) throws -> T where T: Decodable {
    guard let data = mockData else { throw StorageError.notFound(key) }
    return try JSONDecoder().decode(T.self, from: data)
  }

  func remove(for key: String) throws {}
  func exists(for key: String) -> Bool {
    mockData != nil
  }
}

// MockURLSession implementation
final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
  var nextData: Data?
  var nextResponse: URLResponse?
  var nextError: Error?

  func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
    if let error = nextError {
      throw error
    }
    guard let data = nextData,
          let response = nextResponse
    else {
      throw URLError(.unknown)
    }
    return (data, response)
  }
}
