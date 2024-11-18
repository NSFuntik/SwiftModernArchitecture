//
//  Repository.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation

/// Base protocol for repositories
public protocol Repository {
  associatedtype Request
  associatedtype Response
  /// Execute repository operation
  /// - Parameter request: The request object containing the operation's input parameters.
  /// - Returns: An asynchronous response of type `Response`.
  /// - Throws: An error if the operation fails.
  func execute(_ request: Request) async throws -> Response
}

/// Repository for simple operations
public protocol SimpleRepository: Repository where Request == Void {}
/// Repository for CRUD operations
public protocol CRUDRepository: Repository where Request == CRUDRequest<T>, Response == T {
  associatedtype T: Entity
}

/// Standard CRUD operations
public enum CRUDRequest<T: Entity> {
  /// Create a new entity
  case create(T)

  /// Read an entity by its identifier
  case read(T.ID)

  /// Update an existing entity
  case update(T)

  /// Delete an entity by its identifier
  case delete(T.ID)

  /// List all entities
  case list
}
