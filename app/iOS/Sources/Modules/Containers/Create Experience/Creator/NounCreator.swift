//
//  NounCreator.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents

struct NounCreator: View {
  @StateObject var viewModel = ViewModel()
  
  @Namespace private var nsTraitPicker
  @Environment(\.dismiss) private var dismiss
  
  /// Boolean value to determine if the trait picker grid is expanded
  @State private var isExpanded: Bool = false
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        ConditionalSpacer(viewModel.mode == .creating)
        
        SlotMachine(viewModel: .init(initialSeed: viewModel.initialSeed))
        
        ConditionalSpacer(!isExpanded || viewModel.mode != .creating)
        
        if viewModel.mode != .done {
          TraitTypePicker(
            viewModel: viewModel,
            animation: nsTraitPicker,
            isExpanded: $isExpanded
          )
        }
      }
    }
    .modifier(AccessoryItems(viewModel: viewModel, done: {
      withAnimation {
        viewModel.didFinish()
        
        // Dismiss the view automatically when finished editing
        if viewModel.isEditing {
          dismiss()
        }
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
    // Sheet presented when the user is finished creating their
    // noun and is ready to name/save their noun
    .bottomSheet(isPresented: viewModel.mode == .done, showDimmingView: false, allowDrag: false) {
      NounMetadataDialog(viewModel: viewModel)
    }
    // Sheet presented when the user wants to cancel the noun creation process and go to the previous screen
    .bottomSheet(isPresented: viewModel.mode == .cancel, showDimmingView: true, allowDrag: false) {
      DiscardNounSheet(viewModel: viewModel)
    }
    .background(Gradient(.allCases[viewModel.seed.background]))
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
