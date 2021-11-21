//
//  PlayView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

struct PlayView: View {
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Text("Give your noun something to say")
          .font(.custom(.regular, size: 17))
        Spacer()
      }
      .padding(.horizontal, 20)
      .softNavigationTitle("Play")
      .background(Gradient.blueberryJam)
      .ignoresSafeArea()
    }
  }
}

struct Play_Previews: PreviewProvider {
  static var previews: some View {
    PlayView()
  }
}
