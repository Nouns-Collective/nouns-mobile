//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI

@main
struct AppMain: App {
  
//  let store: AppStore!
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .preferredColorScheme(.light)
//        .environmentObject(store)
    }
  }
}

