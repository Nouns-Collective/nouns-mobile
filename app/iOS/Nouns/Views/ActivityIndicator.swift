//
//  ActivityIndicator.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

struct ActivityIndicator: View {
  
  var body: some View {
    VStack {
      GIFImage("noun")
//        .frame(height: 350)
      
//      PilledButton(
//        systemImage: "arrow.clockwise",
//        text: "Try again",
//        action: {},
//        appearance: .dark)
    }
  }
}

struct ActivityIndicator_Preview: PreviewProvider {
  static var previews: some View {
    ActivityIndicator()
  }
}
