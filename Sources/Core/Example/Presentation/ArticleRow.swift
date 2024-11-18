//
//  ArticleRow.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//

import SwiftUI

public struct ArticleRow: View {
  let article: Article

  public init(article: Article) {
    self.article = article
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(article.title)
        .font(.headline)

      Text(article.description)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .lineLimit(2)

      HStack {
        Text(article.author)
          .font(.caption)
        Spacer()
        Text(article.publishDate.formatted(date: .abbreviated, time: .omitted))
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
    }
    .padding(.vertical, 8)
  }
}
