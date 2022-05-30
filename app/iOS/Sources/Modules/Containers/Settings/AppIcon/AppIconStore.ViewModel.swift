//
//  AppIconStore.ViewModel.swift
//  Nouns
//
//  Created by Krishna Satyanarayana on 2022-04-22.
//

import Foundation
import Services

extension AppIconStore {
  final class ViewModel: ObservableObject {

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.appIcon)
    }

    func onAppIconChanged(_ icon: AppIcon, error: Error?) {
      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.setAlternateAppIcon,
                                        parameters: [
                                          "icon_name": icon.name,
                                          "success": error == nil,
                                          "error": error?.localizedDescription ?? ""
                                        ])
    }
  }
}
