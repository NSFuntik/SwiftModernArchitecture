//
//  DomainError.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation

/// Base error type for domain layer
public enum DomainError: LocalizedError {
  /// Represents a validation error with an associated message.
  case validation(String)

  /// Represents an error where a specified item was not found with an associated item name.
  case notFound(String)

  /// Represents an error for unauthorized access.
  case unauthorized

  /// Represents an unknown error with an associated error object.
  case unknown(Error)
  /// A textual representation of the error that can be displayed to the user.
  public var errorDescription: String? {
    switch self {
    case .validation(let message): return message
    case .notFound(let item): return "\(item) not found"
    case .unauthorized: return "Unauthorized access"
    case .unknown(let error): return error.localizedDescription
    }
  }
}
