//
//  APIClientTests.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
@testable import CoreDomain
@testable import CoreInfrastructure
@testable import CorePresentation
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
    
    let testURL = URL(string: "https://github.com/NSFuntik/SwiftModernArchitecture")!
    mockSession.nextResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
       
    // When
    let responseData: Data = try await client.request(MockEndpoint())
    
    XCTAssertFalse(responseData.isEmpty, "Data is EMPTY")
    
    print("Received: \(String(data: responseData, encoding: .utf8) ?? "Unable to convert to string")")
    
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
