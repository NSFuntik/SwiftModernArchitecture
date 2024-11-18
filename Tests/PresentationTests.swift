//
//  PresentationTests.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

@testable import Presentation
import SwiftUI
import XCTest

@MainActor
final class PresentationTests: XCTestCase {
  func testLoadableViewStates() async {
    // Given
    let mockSource = MockRepository<String>()
    let value = "test"
    mockSource.mockResponse = value
       
    // When
    let view = LoadableView(
      source: mockSource,
      input: ()
    ) { content in
      Text(content)
    }
       
    // Then - need ViewInspector or similar for proper UI testing
    XCTAssertNotNil(view)
  }
   
  func testPaginatedViewLoading() async {
    // Given
    let mockSource = MockRepository<[String]>()
    mockSource.mockResponse = ["1", "2", "3"]
       
    // When
    let view = PaginatedView(
      source: mockSource,
      input: { _ in () }
    ) { item in
      Text(item)
    }
       
    // Then
    XCTAssertNotNil(view)
  }
}

extension String: @retroactive Identifiable {
  public var id: Self { self }
}
