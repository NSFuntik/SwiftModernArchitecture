//
//  NetworkManager.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 12/3/24.
//
@_exported import Domain
import Foundation

public final class NetworkManager: NetworkManaging {
  public static let shared = NetworkManager()
  private let session: URLSession
    
  private init(session: URLSession = .shared) {
    self.session = session
  }
    
  public func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
    let request = try endpoint.urlRequest()
    let (data, response) = try await session.data(for: request)
        
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }
        
    try validateResponse(httpResponse)
        
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingFailed
    }
  }
    
  private func validateResponse(_ response: HTTPURLResponse) throws {
    switch response.statusCode {
    case 200...299:
      return
    case 400...499:
      throw NetworkError.clientError(response.statusCode)
    case 500...599:
      throw NetworkError.serverError(response.statusCode)
    default:
      throw NetworkError.unknownError(response.statusCode)
    }
  }
}
