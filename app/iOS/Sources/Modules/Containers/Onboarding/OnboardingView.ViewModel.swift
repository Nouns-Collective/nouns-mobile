//
//  OnboardingView.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services
import SwiftUI

extension OnboardingView {
  
  /// Lists all Onboarding pages.
  enum Page: Hashable, CaseIterable {
    case intro
    case explore
    case create
    case play
    
    fileprivate var assetFolder: String {
      switch self {
      case .intro:
        return "nouns-onboarding-1"
      case .explore:
        return "nouns-onboarding-2"
      case .create:
        return "nouns-onboarding-3"
      case .play:
        return "nouns-onboarding-4"
      }
    }
    
    fileprivate var numberOfAssets: Int {
      switch self {
      case .intro, .explore, .create, .play:
        return 120
      }
    }
  }
  
  class ViewModel: ObservableObject {
    
    /// Verify whether to show the Onboarding flow.
    @Published var showOnboarding: Bool
    
    /// The currently presented onboarding screen
    @Published var selectedPage: Page = .intro
    
    /// A namespace to define the animation between shared elements in the onboarding views
    @Namespace var onboardingAnimation
    
    /// Store where app configuration is persisted.
    private var settingsStore: SettingsStore
    
    init(settingsStore: SettingsStore = AppCore.shared.settingsStore) {
      self.settingsStore = settingsStore
      showOnboarding = !settingsStore.hasCompletedOnboarding
    }
    
    func toggleCompletionState() {
      settingsStore.hasCompletedOnboarding = true
      
      showOnboarding.toggle()
    }
    
    func onboardingImages() -> [String] {
      let folder = selectedPage.assetFolder
      var images = [String]()
      
      for asset in 0..<selectedPage.numberOfAssets {
        let index = String(format: "%03d", asset)
        let imagePath = "\(folder)/\(folder)_\(index)"
        images.append(imagePath)
      }
      
      return images
    }
  }
}
