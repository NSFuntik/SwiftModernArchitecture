//
//  Feature.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Foundation

/// Base protocol for feature that combines repository and use case
public protocol Feature: Repository {
  associatedtype State
  associatedtype Action
  /// Current feature state
  var state: State { get }
  /// Reduce feature state based on action
  ///
  /// - Parameters:
  ///   - state: The current state of the feature.
  ///   - action: The action to be performed, which may result in a new state.
  /// - Returns: The new state resulting from the given action.
  /// - Throws: An error if the action cannot be performed.
  func reduce(_ state: State, action: Action) async throws -> State
}

/// Base protocol for feature that supports event handling
public protocol EventHandling {
  associatedtype Event
  /// Handle feature event
  ///
  /// - Parameter event: The event to be handled, which may trigger updates to the feature's state
  /// or perform other actions.
  func handle(_ event: Event) async
}

/// Combine Feature with event handling
public typealias EventDrivenFeature = EventHandling & Feature
