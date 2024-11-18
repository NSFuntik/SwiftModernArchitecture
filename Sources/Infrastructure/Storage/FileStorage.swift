//
//  FileStorage.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Foundation

/// File based storage implementation
public final class FileStorage: StorageService {
  /// The file manager used to interact with the file system. Defaults to the shared file manager.
  private let fileManager: FileManager
  /// An optional base URL for the storage location. If `nil`, the default storage location in the documents directory is used.
  private let baseURL: URL
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder
   
  /// Initializes a new instance of `FileStorage` with optional parameters for `fileManager`, `baseURL`, `encoder`, and `decoder`.
  /// - Parameters:
  ///   - fileManager: The file manager used to interact with the file system. Defaults to the shared file manager.
  ///   - baseURL: An optional base URL for the storage location. If `nil`, the default storage location in the documents directory is used.
  ///   - encoder: The JSON encoder used to encode data. Defaults to a new instance of `JSONEncoder`.
  ///   - decoder: The JSON decoder used to decode data. Defaults to a new instance of `JSONDecoder`.
  /// - Throws: `StorageError.invalidPath` if the document directory cannot be located or any error related to creating the directory.
  public init(
    fileManager: FileManager = .default,
    baseURL: URL? = nil,
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
  ) throws {
    self.fileManager = fileManager
    self.encoder = encoder
    self.decoder = decoder
       
    if let baseURL = baseURL {
      self.baseURL = baseURL
    } else {
      let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
      guard let documentURL = urls.first else {
        throw StorageError.invalidPath
      }
      self.baseURL = documentURL.appendingPathComponent("Storage", isDirectory: true)
    }
       
    if !fileManager.fileExists(atPath: self.baseURL.path) {
      try fileManager.createDirectory(at: self.baseURL, withIntermediateDirectories: true)
    }
  }
   
  /// Saves an encodable value to the storage with the given key.
  /// - Parameter value: The value to save, which must conform to the `Encodable` protocol.
  /// - Parameter key: The key under which to store the value.
  /// - Throws: Any error encountered while encoding the value or writing it to disk.
  public func save<T: Encodable>(_ value: T, for key: String) throws {
    let url = baseURL.appendingPathComponent(key)
    let data = try encoder.encode(value)
    try data.write(to: url)
  }
   
  /// Retrieves a decodable value from the storage for the given key.
  /// - Parameter key: The key for which to retrieve the value.
  /// - Returns: The value associated with the given key, decoded to the specified type.
  /// - Throws: Any error encountered while reading the data or decoding it.
  public func retrieve<T: Decodable>(for key: String) throws -> T {
    let url = baseURL.appendingPathComponent(key)
    let data = try Data(contentsOf: url)
    return try decoder.decode(T.self, from: data)
  }
   
  /// Removes the value associated with the given key from the storage.
  /// - Parameter key: The key for which to remove the value.
  /// - Throws: Any error encountered while attempting to remove the item.
  public func remove(for key: String) throws {
    let url = baseURL.appendingPathComponent(key)
    try fileManager.removeItem(at: url)
  }
   
  /// Checks whether a value exists for the given key in the storage.
  /// - Parameter key: The key to check for existence in the storage.
  /// - Returns: A boolean indicating whether the key exists.
  public func exists(for key: String) -> Bool {
    let url = baseURL.appendingPathComponent(key)
    return fileManager.fileExists(atPath: url.path)
  }
}
