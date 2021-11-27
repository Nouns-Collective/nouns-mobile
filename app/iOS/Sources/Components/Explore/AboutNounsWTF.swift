//
//  AboutView.swift
//  Nouns
//
//  Created by Ziad Tamim on 19.11.21.
//

import SwiftUI
import UIComponents

// TODO: All the static text should be placed in `R.generated.swift` file.
struct AboutNounsWTF: View {
  @Environment(\.openURL) private var openURL
  @Binding var isPresented: Bool
  
  init(isPresented: Binding<Bool>) {
    self._isPresented = isPresented
  }
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          NounSpeechBubble(
            R.string.aboutNouns.message(),
            noun: "talking-noun")
            .padding(.horizontal)
          
          Divider()
            .background(Color.componentNounsBlack)
            .frame(height: 2)
          
          Text(R.string.aboutNouns.nounsWtfDescription())
            .font(.custom(.regular, size: 17))
            .lineSpacing(6)
            .padding(.horizontal)
            .padding(.top, 22)
          
          // TODO: Shouldn't leave the app to open the website.
          // Opens `nouns.wtf`
          OutlineButton(
            text: R.string.aboutNouns.learnMore(),
            icon: { Image.web },
            smallAccessory: { Image.squareArrowDown },
            action: {
              if let url = URL(string: "https://nouns.wtf") {
                openURL(url)
              }
            },
            fill: [.width])
            .padding(.horizontal)
            .padding(.top, 25)
        }
        .softNavigationTitle(R.string.aboutNouns.title(), leftAccessory: {
          // Dismiss About Nouns.wtf
          SoftButton(
            icon: { Image.xmark },
            action: { isPresented.toggle() })
        })
      }
      .background(Gradient.lemonDrop)
    }
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutNounsWTF(isPresented: .constant(false))
      .onAppear {
        UIComponents.configure()
      }
  }
}
