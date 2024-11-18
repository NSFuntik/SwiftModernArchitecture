//
//  DomainTests.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
@testable import Domain
@testable import Presentation
import XCTest

final class DomainTests: XCTestCase {
  // MARK: - Entity Tests
   
  func testEntityEquatable() {
    // Given
    struct TestEntity: Entity {
      let id: UUID
      let value: String
    }
       
    let id = UUID()
    let entity1 = TestEntity(id: id, value: "test")
    let entity2 = TestEntity(id: id, value: "test")
    let entity3 = TestEntity(id: UUID(), value: "test")
       
    // Then
    XCTAssertEqual(entity1, entity2)
    XCTAssertNotEqual(entity1, entity3)
  }
   
  // MARK: - ViewState Tests
   
  func testViewStateTransitions() {
    // Given
    let value = "test"
    var state: ViewState<String>
       
    // When - Loading
    state = .loading
    XCTAssertTrue(state.isLoading)
       
    // When - Loaded
    state = .loaded(value)
    XCTAssertEqual(state.value, value)
       
    // When - Failed
    let error = NSError(domain: "test", code: -1)
    state = .failed(error)
    XCTAssertNotNil(state.error)
  }
   
  func testViewStateMapping() {
    // Given
    let stringState: ViewState<String> = .loaded("123")
       
    // When
    let intState = stringState.map { Int($0) ?? 0 }
       
    // Then
    XCTAssertEqual(intState.value, 123)
  }
}
