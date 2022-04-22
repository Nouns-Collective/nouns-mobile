//
//  AboutView.ViewModel.swift
//  Nouns
//
//  Created by Krishna Satyanarayana on 2022-04-21.
//

import Foundation
import Services

extension AboutView {
  final class ViewModel: ObservableObject {

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.about)
    }
  }
}
