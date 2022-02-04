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
  @Namespace private var namespace
  
  @StateObject var viewModel = ViewModel()
  @Environment(\.dismiss) private var dismiss
  
  /// Boolean value to determine if the current noun is being editing (pre-existing) or if it's a new noun being created
  private let isEditing: Bool
  
  /// Boolean value to determine if the trait picker grid is expanded
  @State private var isExpanded: Bool = false
  
  /// The initial seed of the noun creator, reflecting which traits are selected and displayed initially
  private let initialSeed: Seed
  
  /// An action to be carried out when `isEditing` is set to `true` and the user has completed editing their noun
  private var didEditNoun: (_ seed: Seed) -> Void = { _ in }
  
  private var mode: ViewModel.Mode {
    viewModel.mode
  }
    
  init(
    initialSeed: Seed = Seed(background: 0, glasses: 0, head: 0, body: 0, accessory: 0),
    isEditing: Bool = false,
    didEditNoun: @escaping (_ seed: Seed) -> Void = { _ in }
  ) {
    self.initialSeed = initialSeed
    self.isEditing = isEditing
    self.didEditNoun = didEditNoun
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
      // If the user is editing an existing noun, only the designated
      // action should be executed and the created should then be dismissed.
      // Otherwise, confetti appears and a dialog prompting more details is presented
      // before actually saving the new noun
      if isEditing {
        didEditNoun(viewModel.seed)
        dismiss()
      } else {
        withAnimation {
          viewModel.toggleConfetti()
          viewModel.setMode(to: .done)
        }
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
    .onAppear {
      viewModel.seed = initialSeed
    }
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
