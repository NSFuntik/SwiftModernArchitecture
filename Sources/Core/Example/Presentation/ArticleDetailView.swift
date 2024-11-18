//
//  ArticleDetailView.swift
//  SwiftModernArchitecture
//
//  Created by NSFuntik on 11/18/24.
//
import Domain
import Presentation
import SwiftUI

struct ArticleDetailView: View {
  let article: Article
   
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        if let imageURL = article.imageURL {
          AsyncImage(url: imageURL) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          } placeholder: {
            Color.gray.opacity(0.3)
          }
          .frame(height: 200)
          .clipped()
        }
               
        Text(article.title)
          .font(.title)
               
        Text(article.description)
          .font(.body)
               
        HStack {
          VStack(alignment: .leading) {
            Text("Author:")
              .font(.caption)
              .foregroundColor(.secondary)
            Text(article.author)
              .font(.subheadline)
          }
                   
          Spacer()
                   
          VStack(alignment: .trailing) {
            Text("Published:")
              .font(.caption)
              .foregroundColor(.secondary)
            Text(article.publishDate.formatted())
              .font(.subheadline)
          }
        }
        .padding(.top)
      }
      .padding()
    }
  }
}
