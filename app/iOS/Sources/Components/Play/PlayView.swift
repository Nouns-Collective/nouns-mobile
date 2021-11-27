//
//  PlayView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

struct PlayView: View {
  @State private var isPlayPresented = false
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Text(R.string.play.subhealine())
          .font(.custom(.regular, size: 17))
        
//        NounPuzzle(
//          head: Image(nounTraitName: AppCore.shared.nounComposer.heads[26].assetImage),
//          body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[20].assetImage),
//          glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[8].assetImage),
//          accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[0].assetImage))
//          .padding(.top, 40)
        
        OutlineButton(
          text: R.string.play.proceedTitle(),
          largeAccessory: { Image.fingergunsRight },
          action: { isPlayPresented.toggle() },
          fill: [.width])
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .softNavigationTitle(R.string.play.title())
      .background(Gradient.blueberryJam)
      .ignoresSafeArea()
      .fullScreenCover(isPresented: $isPlayPresented) {
        PlayTab(isPresented: $isPlayPresented)
      }
    }
  }
}
