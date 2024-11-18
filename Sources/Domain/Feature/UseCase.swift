//
//  UseCase.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation

/// Base protocol for use cases
public protocol UseCase {
  associatedtype Input
  associatedtype Output
  /// Execute use case operation.
  ///
  /// This function performs the primary operation of the use case, taking an input of type `Input`
  /// and returning a result of type `Output`. The operation is asynchronous and can throw errors.
  ///
  /// - Parameter input: The input parameter needed for executing the use case.
  /// - Returns: A result of type `Output` representing the outcome of the use case execution.
  /// - Throws: An error if the execution fails.
  func execute(_ input: Input) async throws -> Output
}
