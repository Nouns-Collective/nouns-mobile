//
//  NounCreator.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounCreator: View {
  
  @StateObject var viewModel = ViewModel()
    
  @Namespace private var namespace
  
  @State private var isExpanded: Bool = false
  
  private var mode: ViewModel.Mode {
    viewModel.mode
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        ConditionalSpacer(mode == .creating)
        
        SlotMachine(viewModel: viewModel)
        
        ConditionalSpacer(!isExpanded || mode != .creating)
        
        if mode != .done {
          TraitTypePicker(
            viewModel: viewModel,
            animation: namespace,
            isExpanded: $isExpanded
          )
        }
      }
    }
    .modifier(AccessoryItems(viewModel: viewModel, done: {
      withAnimation {
        viewModel.toggleConfetti()
        viewModel.setMode(to: .done)
      }
    }, cancel: {
      withAnimation {
        if mode == .done {
          viewModel.setMode(to: .creating)
        } else {
          viewModel.setMode(to: .cancel)
        }
      }
    }))
    // Sheet presented when the user is finished creating their noun and is ready to name/save their noun
    .bottomSheet(isPresented: mode == .done, showDimmingView: false, allowDrag: false, content: {
      NounMetadataDialog(viewModel: viewModel)
    })
    // Sheet presented when the user wants to cancel the noun creation process and go to the previous screen
    .bottomSheet(isPresented: mode == .cancel, showDimmingView: true, allowDrag: false, content: {
      DiscardNounCreatorSheet(viewModel: viewModel)
    })
    .background(GradientView(GradientColors.allCases[viewModel.seed.background]))
    .overlay {
      EmitterView()
        .zIndex(100)
        .scaleEffect(viewModel.showConfetti ? 1 : 0, anchor: .top)
        .opacity(viewModel.showConfetti && !viewModel.finishedConfetti ? 1 : 0)
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
  }
}
