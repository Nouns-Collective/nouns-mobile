//
//  OnboardingView.ViewModel.swift
//  Nouns
//
//  Created by Krishna Satyanarayana on 2022-04-21.
//

import Foundation
import Services
import UIKit

extension OnboardingView {
  
  final class ViewModel: ObservableObject {
    
    @Published var selectedPage: Page = .intro
    
    @Published var seed: Seed = .default
            
    var onCompletion: () -> Void
    
    init(onCompletion: @escaping () -> Void = {}) {
      self.onCompletion = onCompletion
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.onboarding)
    }
  }
}
