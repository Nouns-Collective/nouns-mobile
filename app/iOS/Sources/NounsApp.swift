//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import Combine
import UIComponents

@main
struct NounsApp: App {
  private let store = AppStore(
    initialState: AppState(),
    reducer: appReducer,
    middlewares: [
      onChainAuctionsMiddleware(),
      onChainNounActivitiesMiddleware(),
      liveAuctionMiddleware(),
    ]
  )
  
  init() {
    UIComponents.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationRootView()
        .environmentObject(store)
        .preferredColorScheme(.light)
    }
  }
}
