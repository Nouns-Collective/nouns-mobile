//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import Combine
import Services

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
func appReduce(state: inout AppState, action: AppAction) {
  switch action {
  case .onChainExplorer(let action):
    onChainExplorerReducer(state: &state.onChainExplorerState, action: action)
  }
}

/// <#Description#>
struct AppState {
  var onChainExplorerState: OnChainExplorerState
}

/// <#Description#>
enum AppAction {
  case onChainExplorer(action: OnChainExplorerAction)
}

@main
struct AppMain: App {
  
//  let store: AppStore!
  
  var body: some Scene {
    WindowGroup {
      RootView()
//        .environmentObject(store)
    }
  }
}
