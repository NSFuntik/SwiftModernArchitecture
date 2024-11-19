//
//  Article.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import CoreDomain
import Foundation

public struct Article: Entity {
  public let id: UUID
  public let title: String
  public let description: String
  public let author: String
  public let publishDate: Date
  public let imageURL: URL?

  public init(
    id: UUID = UUID(),
    title: String,
    description: String,
    author: String,
    publishDate: Date = Date(),
    imageURL: URL? = nil
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.author = author
    self.publishDate = publishDate
    self.imageURL = imageURL
  }
}
