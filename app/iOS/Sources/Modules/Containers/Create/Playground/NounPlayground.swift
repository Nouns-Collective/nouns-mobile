//
//  NounPlaygroundView.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounPlayground: View {
  @StateObject var viewModel = ViewModel()

  @Environment(\.dismiss) private var dismiss
  
  @Namespace private var namespace

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        Spacer()
        SlotMachine(viewModel: viewModel)
        Spacer()
      }
    }
    // Resuable components to close & back buttons...
    .modifier(AccessoryItems(dismiss: {
      dismiss()
    }))
    .background(Gradient.bubbleGum)
  }
}

struct NounPlaygroundView_Previews: PreviewProvider {
  static var previews: some View {
    NounPlayground()
  }
}
