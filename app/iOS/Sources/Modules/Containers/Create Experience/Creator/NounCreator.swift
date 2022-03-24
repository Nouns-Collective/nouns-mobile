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
  @EnvironmentObject var bottomSheetManager: BottomSheetManager
  
  @Namespace private var nsTraitPicker
  @Environment(\.dismiss) private var dismiss
  
  /// Boolean value to determine if the trait picker grid is expanded
  @State private var isExpanded: Bool = false
  
  private let confettiBundle = Bundle(path: Bundle.main.bundleURL.appendingPathComponent("nounfetti.bundle").path)
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        ConditionalSpacer(viewModel.mode == .creating)
        
        SlotMachine(initialSeed: viewModel.initialSeed)
        
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
    .addBottomSheet()
    .background(Gradient(.allCases[viewModel.seed.background]))
    .overlay {
      NounfettiView()
        .zIndex(100)
        .hidden(!viewModel.showConfetti || viewModel.finishedConfetti)
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
    .onChange(of: viewModel.mode) { mode in
      switch mode {
      case .done:
        // Sheet presented when the user is finished creating their
        // noun and is ready to name/save their noun
        bottomSheetManager.showBottomSheet(
          style: .init(showDimmingView: false)
        ) {
          viewModel.mode = .creating
        } content: {
          NounMetadataDialog(viewModel: viewModel)
        }
      case .cancel:
        // Sheet presented when the user wants to cancel the noun
        // creation process
        bottomSheetManager.showBottomSheet {
          viewModel.mode = .creating
        } content: {
          DiscardNounSheet(viewModel: viewModel)
        }
      case .creating:
        bottomSheetManager.closeBottomSheet()
      }
    }
    .onShake {
      NotificationCenter.default.post(name: Notification.Name.slotMachineShouldShowAllTraits, object: true)

      withAnimation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0)) {
        viewModel.randomizeNoun()
      }
      
      withAnimation(.spring().delay(3.0)) {
        NotificationCenter.default.post(name: Notification.Name.slotMachineShouldShowAllTraits, object: false)
      }
    }
  }
}
