//
//  Mapper.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Foundation

/// Protocol for mapping between different entity types
public protocol Mapper {
  associatedtype Input
  associatedtype Output
  /// A method that maps the given input of type `Input` to an output of type `Output`.
  /// - Parameter input: The input value to be mapped.
  /// - Throws: An error if the mapping process fails.
  /// - Returns: The mapped output value.
  func map(_ input: Input) throws -> Output
}

/// Default implementation for self-mapping
public extension Mapper where Input == Output {
  /// A method that returns the input value as the output when the input and output types are the same.
  /// - Parameter input: The input value to be returned as output.
  /// - Throws: An error if the mapping process fails, although in this case it will not.
  /// - Returns: The input value as the output value.
  func map(_ input: Input) throws -> Output {
    return input
  }
}
