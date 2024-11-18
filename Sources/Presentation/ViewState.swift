//
//  ViewState.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import Foundation

/// Represents different states of data loading and presentation
public enum ViewState<T> {
  /// Initial or loading state
  case loading
   
  /// Successfully loaded state with data
  case loaded(T)
   
  /// Empty state with optional message
  case empty(String = "No data available")
   
  /// Error state
  case failed(Error)
   
  /// Check if state is loading
  public var isLoading: Bool {
    if case .loading = self { return true }
    return false
  }
   
  /// Get loaded value if available
  public var value: T? {
    if case .loaded(let value) = self { return value }
    return nil
  }
   
  /// Get error if state is failed
  public var error: Error? {
    if case .failed(let error) = self { return error }
    return nil
  }
   
  /// Map loaded value to different type
  public func map<U>(_ transform: (T) -> U) -> ViewState<U> {
    switch self {
    case .loading:
      return .loading
    case .loaded(let value):
      return .loaded(transform(value))
    case .empty(let message):
      return .empty(message)
    case .failed(let error):
      return .failed(error)
    }
  }
}

/// Collection view state with pagination support
/// A structure that holds the state of a paginated collection view, including the current items,
/// the current page, whether more items are available, any potential error, and
/// whether the state is currently loading.
public struct PaginatedState<T> {
  ///  The current collection of items, defaults to an empty array.
  public var items: [T]
  ///  The current page index, defaults to 0.
  public var currentPage: Int
  ///  A Boolean value indicating if there is a next page available, defaults to `true`.
  public var hasNextPage: Bool
  ///  An optional error that may have occurred, defaults to `nil`.
  public var error: Error?
  ///  A Boolean value indicating whether data is currently being loaded, defaults to `false`.
  public var isLoading: Bool
   
  /// Initializes a new instance of `PaginatedState`.
  /// - Parameters:
  ///   - items: The current collection of items, defaults to an empty array.
  ///   - currentPage: The current page index, defaults to 0.
  ///   - hasNextPage: A Boolean value indicating if there is a next page available, defaults to `true`.
  ///   - error: An optional error that may have occurred, defaults to `nil`.
  ///   - isLoading: A Boolean value indicating whether data is currently being loaded, defaults to `false`.
  public init(
    items: [T] = [],
    currentPage: Int = 0,
    hasNextPage: Bool = true,
    error: Error? = nil,
    isLoading: Bool = false
  ) {
    self.items = items
    self.currentPage = currentPage
    self.hasNextPage = hasNextPage
    self.error = error
    self.isLoading = isLoading
  }
}

extension PaginatedState: Equatable where T: Equatable {
  public static func == (lhs: PaginatedState<T>, rhs: PaginatedState<T>) -> Bool {
    return lhs.items == rhs.items &&
      lhs.currentPage == rhs.currentPage &&
      lhs.hasNextPage == rhs.hasNextPage &&
      lhs.isLoading == rhs.isLoading
  }
}

extension ViewState: Equatable where T: Equatable {
  public static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (.loaded(let lhs), .loaded(let rhs)):
      return lhs == rhs
    case (.empty(let lhs), .empty(let rhs)):
      return lhs == rhs
    case (.failed(let lhs), .failed(let rhs)):
      return lhs.localizedDescription == rhs.localizedDescription
    default:
      return false
    }
  }
}
