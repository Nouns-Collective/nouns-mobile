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
    
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          NounSpeechBubble("One noun, every day, forever.", noun: "talking-noun")
            .padding(.horizontal)
          
          Divider()
            .background(Color.componentNounsBlack)
            .frame(height: 2)
          
          Text("Nouns are an experimental attempt to improve the formation of on-chain avatar communities. \n\nWhile some projects have attempted to bootstrap digital community and identity, Nouns attempt to bootstrap identity, community, governance and a treasury that can be used by the community for the creation of long-term value.")
            .font(.custom(.regular, size: 17))
            .lineSpacing(6)
            .padding(.horizontal)
            .padding(.top, 22)
          
          // TODO: Shouldn't leave the app to open the website.
          // Opens `nouns.wtf`
          OutlineButton(
            text: "Learn more at nouns.wtf",
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
        .softNavigationTitle("About Nouns", leftAccessory: {
          // Dismiss About Nouns.wtf
          SoftButton(
            icon: { Image.back },
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
