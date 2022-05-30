//
//  AboutView.Section.DerivativeProjects.swift
//  Nouns
//
//  Created by Ziad Tamim on 19.02.22.
//

import SwiftUI
import NounsUI

struct DerivativeProjectsInfoSection: View {
  
  /// A boolean to load the noun.center link using a browser.
  @State private var isNounsCenterPresented = false
  
  /// Holds a reference to the localized text.
  private let localize = R.string.derivativeProjects.self
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      
      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())
      
      OutlineButton(
        text: localize.nounsCenterTitle(),
        smallAccessory: { Image.smArrowOut },
        action: { isNounsCenterPresented.toggle() })
        .controlSize(.large)
    }
    .fullScreenCover(isPresented: $isNounsCenterPresented) {
      if let url = URL(string: localize.nounsCenterLink()) {
        Safari(url: url)
      }
    }
  }
}
