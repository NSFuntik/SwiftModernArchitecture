//
//  ArticlesViewModel.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import CoreDomain
import Foundation
import CoreInfrastructure

@MainActor
public final class ArticlesViewModel: ObservableObject {
  // MARK: - Properties
   
  @Published private(set) var feature: ArticlesFeature
   
  public init(feature: ArticlesFeature) {
    self.feature = feature
  }

  // MARK: - Public Methods
  
  public func search(query: String) async {
    _ = try? await feature.reduce(feature.state, action: .search(query))
  }
   
  // MARK: - Preview Helper
   
  public static func preview(url: URL) -> ArticlesViewModel {
    let apiClient = APIClient(config: .init(baseURL: url))
    let storage = UserDefaultsStorage()
    let feature = ArticlesFeature(apiClient: apiClient, storage: storage)
    return ArticlesViewModel(feature: feature)
  }
}
