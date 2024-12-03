//
//  NetworkManaging.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 12/3/24.
//

import Foundation

public protocol NetworkManaging {
  func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}
