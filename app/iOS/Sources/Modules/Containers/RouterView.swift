//
//  ContentView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents
import Services

extension RouterView {
  
  final class ViewModel: ObservableObject {
    private let settingsStore: SettingsStore
    
    init(settingsStore: SettingsStore = AppCore.shared.settingsStore) {
      self.settingsStore = settingsStore
    }
    
    var shouldPresentOnboardingFlow: Bool {
      !settingsStore.hasCompletedOnboarding
    }
  }
}

struct RouterView: View {
  @StateObject var viewModel = ViewModel()
  
  @State private var selectedTab = 0
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    // TODO: Enhancing OutlineTabView API by prodviding a view modifier to construct the tab items
    OutlineTabView(selection: $selectedTab) {
      ExploreExperience()
        .outlineTabItem(normal: "explore-outline", selected: "explore-fill", tag: 0)
      
      CreateExperience()
        .outlineTabItem(normal: "create-outline", selected: "create-fill", tag: 1)
      
      PlayExperience()
        .outlineTabItem(normal: "play-outline", selected: "play-fill", tag: 2)
      
      AboutView()
        .outlineTabItem(normal: "settings-outline", selected: "settings-fill", tag: 3)
    }
    .onboarding()
  }
}
