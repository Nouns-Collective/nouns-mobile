//
//  AboutView.swift
//  Nouns
//
//  Created by Ziad Tamim on 19.11.21.
//

import SwiftUI
import NounsUI

struct AboutNounsView: View {
  @Binding var isPresented: Bool
  
  @State private var isSafariPresented = false
  
  /// Holds a reference to the localized text.
  private let localize = R.string.aboutNouns.self
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      HStack(alignment: .top) {
        Image(R.image.noun.name)
          .padding(0)
          .offset(x: -20)
        
        Spacer()
        
        // Dismiss About Nouns.wtf
        SoftButton(
          icon: { Image.xmark },
          action: {
            withAnimation {
              isPresented.toggle()
            }
          })
      }
        
      // Content
      Text(localize.title())
        .font(.custom(.bold, relativeTo: .title2))
      
      Text(localize.nounsWtfDescription())
        .font(.custom(.regular, relativeTo: .subheadline))
        .lineSpacing(7)
      
      // Opens `nouns.wtf`
      SoftButton(
        text: localize.learnMore(),
        largeAccessory: { Image.web },
        action: { isSafariPresented.toggle() })
        .controlSize(.large)
        .padding(.top, 25)
    }
    .padding(20)
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let url = URL(string: R.string.shared.nounsWebsite()) {
        Safari(url: url)
      }
    }
  }
}

struct AboutNounsView_Previews: PreviewProvider {
  
  static var previews: some View {
    Text("About")
      .background(Gradient.bubbleGum)
      .bottomSheet(isPresented: .constant(true)) {
        AboutNounsView(isPresented: .constant(false))
      }
      .onAppear {
        NounsUI.configure()
      }
  }
}
