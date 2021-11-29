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
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    // TODO: Enhancing OutlineTabView API by prodviding a view modifier to construct the tab items
    OutlineTabView(selection: $selectedTab) {
      OnChainExplorerView()
        .outlineTabItem(normal: "explore-outline", selected: "explore-fill", tag: 0)
      
      CreateExperience()
        .outlineTabItem(normal: "create-outline", selected: "create-fill", tag: 1)
      
      PlayView()
        .outlineTabItem(normal: "play-outline", selected: "play-fill", tag: 2)
      
      SettingsView()
        .outlineTabItem(normal: "settings-outline", selected: "settings-fill", tag: 3)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationRootView()
  }
}
