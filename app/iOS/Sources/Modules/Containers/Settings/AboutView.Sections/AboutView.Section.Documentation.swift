//
//  DocumentationInfoSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct DocumentationInfoSection: View {
  @State private var isDocsPresented = false
  private let localize = R.string.documentation.self
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())
      
      OutlineButton(
        text: localize.learnMore(),
        smallAccessory: { Image.smArrowOut },
        action: { isDocsPresented.toggle() })
        .controlSize(.large)
    }
    .fullScreenCover(isPresented: $isDocsPresented) {
      if let url = URL(string: localize.documentationLink()) {
        Safari(url: url)
      }
    }
  }
}
