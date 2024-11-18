//
//  UserDefaultsStorage.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Foundation

/// UserDefaults based storage implementation
public final class UserDefaultsStorage: StorageService {
  private let defaults: UserDefaults
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder
   
  /// Initializes a new instance of `UserDefaultsStorage`.
  ///
  /// - Parameters:
  ///   - defaults: The `UserDefaults` instance to use for storage. Defaults to `.standard`.
  ///   - encoder: The `JSONEncoder` instance used for encoding values. Defaults to a new instance of `JSONEncoder`.
  ///   - decoder: The `JSONDecoder` instance used for decoding values. Defaults to a new instance of `JSONDecoder`.
  public init(
    defaults: UserDefaults = .standard,
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
  ) {
    self.defaults = defaults
    self.encoder = encoder
    self.decoder = decoder
  }
   
  /// Saves a value to storage.
  ///
  /// - Parameters:
  ///   - value: The value to be saved, which must conform to the `Encodable` protocol.
  ///   - key: The key under which the value will be stored.
  /// - Throws: An error if the value cannot be encoded.
  public func save<T: Encodable>(_ value: T, for key: String) throws {
    let data = try encoder.encode(value)
    defaults.set(data, forKey: key)
  }
   
  /// Retrieves a value from storage.
  ///
  /// - Parameter key: The key associated with the value to retrieve.
  /// - Returns: The retrieved value, which conforms to the `Decodable` protocol.
  /// - Throws: An error if the data is not found or cannot be decoded.
  public func retrieve<T: Decodable>(for key: String) throws -> T {
    guard let data = defaults.data(forKey: key) else {
      throw StorageError.notFound(key)
    }
       
    return try decoder.decode(T.self, from: data)
  }
   
  /// Removes a value from storage.
  ///
  /// - Parameter key: The key associated with the value to remove.
  /// - Throws: An error if the value cannot be removed.
  public func remove(for key: String) throws {
    defaults.removeObject(forKey: key)
  }
   
  /// Checks if a value exists for the given key.
  ///
  /// - Parameter key: The key to check for existence.
  /// - Returns: A Boolean value indicating whether a value exists for the given key.
  public func exists(for key: String) -> Bool {
    defaults.object(forKey: key) != nil
  }
}
