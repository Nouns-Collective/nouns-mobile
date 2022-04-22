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
  
  @State private var selectedTab: Page = .explore
  
  @StateObject private var tabBarVisibilityManager = OutlineTabBarVisibilityManager()
  
  @State private var isOnboardingPresented = !AppCore.shared.settingsStore.hasCompletedOnboarding
    
  private enum Page: Int {
    case explore
    case create
    case about
  }
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
    
    // Hides the UITabBar that appears when using SwiftUI's
    // `TabView` so we can show only `OutlineTabBar` instead. 
    UITabBar.appearance().alpha = 0
  }
  
  private let items = [
    OutlineTabItem(normalStateIcon: .exploreOutline, selectedStateIcon: .exploreFill, tag: Page.explore),
    OutlineTabItem(normalStateIcon: .createOutline, selectedStateIcon: .createFill, tag: Page.create),
    OutlineTabItem(normalStateIcon: .aboutOutline, selectedStateIcon: .aboutFill, tag: Page.about)
  ]
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
      if !isOnboardingPresented {
        TabView(selection: $selectedTab) {
          ExploreExperience()
            .tag(Page.explore)

          CreateExperience()
            .tag(Page.create)

          AboutView()
            .tag(Page.about)
        }
        .ignoresSafeArea(.all)
      }
      
      OutlineTabBar(selection: $selectedTab, items)
    }
    .onboarding($isOnboardingPresented) {
      // On completion of onboarding, toggle the local setting store to reflect the completion state so we show the onboarding on the first launch only
      AppCore.shared.settingsStore.hasCompletedOnboarding = true
    }
    .addBottomSheet()
    .environment(\.outlineTabBarVisibility, tabBarVisibilityManager)
  }
}
