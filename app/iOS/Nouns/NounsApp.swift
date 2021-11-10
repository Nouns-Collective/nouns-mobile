//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents

@main
struct NounsApp: App {
  
  init() {
    UIComponents.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
