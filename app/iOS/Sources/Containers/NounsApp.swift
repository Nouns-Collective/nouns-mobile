//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import Combine
import UIComponents
import Services

struct NounComposerKey: EnvironmentKey {
  static var defaultValue: NounComposer = AppCore.shared.nounComposer
}

extension EnvironmentValues {
    
    var nounComposer: NounComposer {
        get { self[NounComposerKey.self] }
        set { self[NounComposerKey.self] = newValue }
    }
}

@main
struct NounsApp: App {
  @StateObject private var store = AppStore(
    initialState: AppState(),
    reducer: appReducer,
    middlewares: [
      auctionsMiddleware(),
      activityMiddleware(),
      bidMiddleware()
    ]
  )
  
  private var nounComposer = AppCore.shared.nounComposer
  private var persistenceStore = PersistenceStore.shared
  
  init() {
    UIComponents.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      RouterView()
        .environmentObject(store)
        .environment(\.nounComposer, nounComposer)
        .environment(\.managedObjectContext, persistenceStore.viewContext)
        .preferredColorScheme(.light)
    }
  }
}
