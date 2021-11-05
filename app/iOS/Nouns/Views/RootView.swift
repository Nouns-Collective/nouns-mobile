//
//  ContentView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI

struct RootView: View {
  var body: some View {
    OnChainExplorerView()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
      .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
  }
}
