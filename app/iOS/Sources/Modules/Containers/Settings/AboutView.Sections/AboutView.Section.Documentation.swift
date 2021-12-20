//
//  DocumentationInfoSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct DocumentationInfoSection: View {
  @State private var isNotionDocsPresented = false
  private let localize = R.string.documentation.self
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())
      
      OutlineButton(
        text: localize.notionDocs(),
        smallAccessory: { Image.smArrowOut },
        action: { isNotionDocsPresented.toggle() })
        .controlSize(.large)
    }
    .fullScreenCover(isPresented: $isNotionDocsPresented) {
      if let url = URL(string: localize.notionLink()) {
        Safari(url: url)
      }
    }
  }
}
