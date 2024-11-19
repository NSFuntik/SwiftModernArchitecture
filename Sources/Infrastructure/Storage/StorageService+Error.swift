//
//  StorageService.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import CoreDomain
import Foundation

/// Protocol for storing and retrieving data
public protocol StorageService {
  /// Saves an encodable value to storage associated with a specified key.
  /// - Parameters:
  ///   - value: The value to be stored, which must conform to the `Encodable` protocol.
  ///   - key: The key associated with the stored value.
  /// - Throws: An error if the value cannot be saved.
  func save<T: Encodable>(_ value: T, for key: String) throws

  /// Retrieves a decodable value from storage for a specified key.
  /// - Parameter key: The key associated with the stored value.
  /// - Returns: The retrieved value, which conforms to the `Decodable` protocol.
  /// - Throws: An error if the value cannot be retrieved or decoded.
  func retrieve<T: Decodable>(for key: String) throws -> T

  /// Removes the value associated with a specified key from storage.
  /// - Parameter key: The key associated with the value to be removed.
  /// - Throws: An error if the value cannot be removed.
  func remove(for key: String) throws

  /// Checks whether a value exists in storage for a specified key.
  /// - Parameter key: The key to check for existence.
  /// - Returns: A boolean indicating whether a value exists for the specified key.
  func exists(for key: String) -> Bool
}

/// Storage error types
public enum StorageError: LocalizedError {
  /// Represents an error when a value is not found for a specified key.
  case notFound(String)

  /// Represents an error when there is an invalid storage path.
  case invalidPath

  /// Represents an error that occurs when encoding a value fails.
  case encodingFailed(Error)

  /// Represents an error that occurs when decoding a value fails.
  case decodingFailed(Error)

  case saveFailed(Error)

  /// A description of the error based on its type.
  public var errorDescription: String? {
    switch self {
    case .notFound(let key):
      return "Value not found for key: \(key)"
    case .invalidPath:
      return "Invalid storage path"
    case .encodingFailed(let error):
      return "Failed to encode: \(error.localizedDescription)"
    case .decodingFailed(let error):
      return "Failed to decode: \(error.localizedDescription)"
    case .saveFailed(let error):
      return "Failed to save: \(error.localizedDescription)"
    }
  }
}
