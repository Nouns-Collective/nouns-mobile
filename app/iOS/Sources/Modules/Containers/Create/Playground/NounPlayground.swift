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
  
  @State var name: String = ""
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        ConditionalSpacer(viewModel.mode == .creating)
        
        SlotMachine(viewModel: viewModel)
        
        Spacer()
        
        if viewModel.mode == .creating {
          TraitTypePicker(
            viewModel: viewModel,
            animation: namespace
          )
        }
      }
    }
    .modifier(AccessoryItems(viewModel: viewModel, done: {
      withAnimation {
        viewModel.setMode(to: .done)
      }
    }, cancel: {
      withAnimation {
        if viewModel.mode == .done {
          viewModel.setMode(to: .creating)
        } else {
          viewModel.setMode(to: .cancel)
        }
      }
    }))
    .bottomSheet(isPresented: viewModel.mode == .done, showDimmingView: false, allowDrag: false, content: {
      NounMetadataDialog(viewModel: viewModel)
    })
    .bottomSheet(isPresented: viewModel.mode == .cancel, showDimmingView: true, allowDrag: false, content: {
      DiscardNounPlaygroundSheet(viewModel: viewModel)
    })
    .background(Gradient.bubbleGum)
  }
}
