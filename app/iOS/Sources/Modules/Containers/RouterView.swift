//
//  ContentView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents
import Services

enum AppPage: Int {
  case explore
  case create
  case about

  var scrollToTopId: String {
    "\(self.rawValue)_top"
  }
}

extension RouterView {
  
  final class ViewModel: ObservableObject {
    
    @Published public var selectedTab: AppPage = .explore

    @Published public var tappedTwice = false
    
    private let settingsStore: SettingsStore

    public var onTabPress: Binding<AppPage> {
      Binding(
        get: { self.selectedTab },
        set: { tab in
          if tab == self.selectedTab {
            self.tappedTwice = true
          }
          self.selectedTab = tab
        }
      )
    }
    
    init(settingsStore: SettingsStore = AppCore.shared.settingsStore) {
      self.settingsStore = settingsStore
    }
    
    var shouldPresentOnboardingFlow: Bool {
      !settingsStore.hasCompletedOnboarding
    }
    
    func didOpenFromWidget() {
      selectedTab = .explore
    }
  }
}

struct RouterView: View {

  @StateObject var viewModel = ViewModel()

  @StateObject private var tabBarVisibilityManager = OutlineTabBarVisibilityManager()

  @State private var isOnboardingPresented = !AppCore.shared.settingsStore.hasCompletedOnboarding
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
    
    // Hides the UITabBar that appears when using SwiftUI's
    // `TabView` so we can show only `OutlineTabBar` instead. 
    UITabBar.appearance().alpha = 0
  }
  
  private let items = [
    OutlineTabItem(normalStateIcon: .exploreOutline, selectedStateIcon: .exploreFill, tag: AppPage.explore),
    OutlineTabItem(normalStateIcon: .createOutline, selectedStateIcon: .createFill, tag: AppPage.create),
    OutlineTabItem(normalStateIcon: .aboutOutline, selectedStateIcon: .aboutFill, tag: AppPage.about)
  ]
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
      if !isOnboardingPresented {
        SwiftUI.ScrollViewReader { proxy in
          TabView(selection: $viewModel.selectedTab) {
            ExploreExperience()
              .tag(AppPage.explore)

            CreateExperience()
              .tag(AppPage.create)

            AboutView()
              .tag(AppPage.about)
          }
          .onChange(of: viewModel.tappedTwice, perform: { tappedTwice in
            if tappedTwice {
              withAnimation {
                proxy.scrollTo(viewModel.selectedTab.scrollToTopId, anchor: .top)
              }
            }
            viewModel.tappedTwice = false
          })
          .ignoresSafeArea(.all)
        }
      }

      OutlineTabBar(selection: viewModel.onTabPress, items)
    }
    .onboarding($isOnboardingPresented) {
      // On completion of onboarding, toggle the local setting store to reflect the completion state so we show the onboarding on the first launch only
      AppCore.shared.settingsStore.hasCompletedOnboarding = true
    }
    .addBottomSheet()
    .environment(\.outlineTabBarVisibility, tabBarVisibilityManager)
    .onWidgetOpen {
      viewModel.didOpenFromWidget()
    }
  }
}

extension View {
  
  /// A view extension that performs an action when the app is opened from iOS widget
  func onWidgetOpen(_ action: @escaping () -> Void) -> some View {
    self
      .onOpenURL { url in
        if url == URL(string: "nouns:///live-auction") {
          action()
        }
      }
  }
}
