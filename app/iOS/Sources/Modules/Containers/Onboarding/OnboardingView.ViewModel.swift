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
  }
  
  class ViewModel: ObservableObject {
    /// Verify weather to show the Onboarding flow.
    @Published var showOnboarding: Bool
    
    /// The currently presented onboarding screen
    @Published var selectedPage: Page = .intro
    
    /// A namespace to define the animation between shared elements in the onboarding views
    @Namespace var onboardingAnimation
    
    /// Store where app configuration is persisted.
    private let settingsStore: SettingsStore
    
    init(settingsStore: SettingsStore = AppCore.shared.settingsStore) {
      self.settingsStore = settingsStore
      showOnboarding = !settingsStore.hasCompletedOnboarding
    }
    
    func toggleCompletionState() {
      settingsStore.hasCompletedOnboarding = true
      
      showOnboarding.toggle()
    }
  }
}
