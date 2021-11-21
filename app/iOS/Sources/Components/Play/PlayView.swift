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
        
        NounPuzzle(
          head: Image(nounTraitName: AppCore.shared.nounComposer.heads[26].assetImage),
          body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[20].assetImage),
          glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[8].assetImage),
          accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[0].assetImage))
          .padding(.top, 40)
        
        OutlineButton(
          text: "Get going",
          largeAccessory: { Image.fingergunsRight },
          action: { },
          fill: [.width])
        
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
