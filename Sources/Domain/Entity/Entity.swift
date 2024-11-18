//
//  Entity.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Foundation

/// Base protocol for all domain entities
///
/// The `Entity` protocol serves as a foundational interface for all domain entities
/// within the system. It inherits from the `Identifiable`, `Codable`, and `Equatable`
/// protocols, ensuring that entities can be uniquely identified, encoded/decoded
/// for data persistence, and compared for equality.
///
/// It is constrained to only allow types where the associated `ID` type is both
/// `Codable` and `Hashable`, thus enabling the use of these entities in various data
/// structures that require hashing capabilities.
public protocol Entity: Identifiable, Codable, Equatable where ID: Codable & Hashable {}
/// Additional domain entity protocols if needed
///
/// The `AggregateRoot` protocol indicates that a certain entity can serve as an
/// aggregate root in the context of Domain-Driven Design. This implies that
/// it may contain references to other entities and value objects while managing
/// their lifecycle and consistency as a cohesive unit.
public protocol AggregateRoot: Entity {}
