//
//  ContentView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents

struct NavigationRootView: View {
  @State private var selectedTab = 0
  
  var body: some View {
    OutlineTabView(selection: $selectedTab) {
      OnChainExplorerView()
        .outlineTabItem(normal: "explore-outline", selected: "explore-fill", tag: 0)
      
      Gradient.bubbleGum
        .outlineTabItem(normal: "create-outline", selected: "create-fill", tag: 1)
      
      Gradient.lemonDrop
        .outlineTabItem(normal: "play-outline", selected: "play-fill", tag: 2)
      
      Gradient.orangesicle
        .outlineTabItem(normal: "settings-outline", selected: "settings-fill", tag: 3)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationRootView()
  }
}
