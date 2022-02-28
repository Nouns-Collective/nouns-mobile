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
  
  private enum Page: Int {
    case explore
    case create
    case play
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
    OutlineTabItem(normalStateIcon: .playOutline, selectedStateIcon: .playFill, tag: Page.play),
    OutlineTabItem(normalStateIcon: .aboutOutline, selectedStateIcon: .aboutFill, tag: Page.about)
  ]
  
  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $selectedTab) {
        ExploreExperience()
          .tag(Page.explore)
        
        CreateExperience()
          .tag(Page.create)
        
        PlayExperience()
          .tag(Page.play)
        
        AboutView()
          .tag(Page.about)
      }
      .ignoresSafeArea(.all)
      
      OutlineTabBar(selection: $selectedTab, items)
    }
    .onboarding()
    .addBottomSheet()
  }
}
