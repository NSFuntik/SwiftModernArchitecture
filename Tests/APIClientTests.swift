//
//  APIClientTests.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
@testable import Domain
@testable import Infrastructure
@testable import Presentation
import XCTest

final class APIClientTests: XCTestCase {
  var client: MockAPIClient!
  var mockSession: MockURLSession!
   
  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    client = MockAPIClient(config: MockAPIClient.config, session: mockSession)
  }
   
  func testSuccessfulRequest() async throws {
    // Given
    struct TestResponse: Codable, Equatable {
      let value: String
    }
       
    let expectedResponse = TestResponse(value: "test")
    mockSession.nextData = try JSONEncoder().encode(expectedResponse)
    mockSession.nextResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
       
    // When
    let responseData: Data = try await client.request(MockEndpoint())
    let response: TestResponse = try JSONDecoder().decode(TestResponse.self, from: responseData)
    // Then
    XCTAssertEqual(response, expectedResponse)
  }
   
  func testFailedRequest() async throws {
    // Given
    mockSession.nextError = URLError(.badServerResponse)
       
    // When/Then
    do {
      let _: Data = try await client.request(MockEndpoint())
      XCTFail("Expected error")
    } catch let error as NetworkError {
      // Обновите эту проверку, чтобы она соответствовала фактической ошибке
      XCTAssertEqual(error, .networkFailed(URLError(.badServerResponse)))
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}

// Добавьте эту реализацию, если её нет в другом месте
extension MockAPIClient {
  static let config = APIConfig(baseURL: URL(string: "https://test.com")!)
}

// Конец файла
