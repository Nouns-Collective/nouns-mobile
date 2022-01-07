//
//  PlayExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents
import Services

struct PlayExperience: View {
  @Environment(\.outlineTabViewHeight) var tabBarHeight
  @State private var isPlayPresented = false
  
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.play.subheadline())
          .font(.custom(.regular, size: 17))
        
        NounPuzzle(
          head: AppCore.shared.nounComposer.heads[26].assetImage,
          body: AppCore.shared.nounComposer.bodies[20].assetImage,
          glasses: AppCore.shared.nounComposer.glasses[8].assetImage,
          accessory: AppCore.shared.nounComposer.accessories[0].assetImage)
          .padding(.top, 40)
        
        OutlineButton(
          text: R.string.play.proceedTitle(),
          largeAccessory: { Image.fingergunsRight },
          action: { isPlayPresented.toggle() })
          .controlSize(.large)
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun card and the top of the tab view
      .padding(.bottom, 20)
      .softNavigationTitle(R.string.play.title())
      .background(Gradient.blueberryJam)
      .ignoresSafeArea(edges: .top)
      .fullScreenCover(isPresented: $isPlayPresented) {
        NounPlayground(isPresented: $isPlayPresented)
      }
    }
  }
}
