// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI

struct NounCreator: View {
  @StateObject var viewModel = ViewModel()
  @EnvironmentObject var bottomSheetManager: BottomSheetManager
  
  @Namespace private var nsTraitPicker
  @Environment(\.dismiss) private var dismiss
    
  var body: some View {
    ZStack {
      BackgroundPicker(viewModel: viewModel)
        .ignoresSafeArea(.all)
        
      VStack(spacing: 0) {
        ConditionalSpacer(viewModel.mode == .creating)
        
        SlotMachine(
          seed: $viewModel.seed,
          shouldShowAllTraits: $viewModel.shouldShowAllTraits,
          initialSeed: viewModel.initialSeed,
          currentModifiableTraitType: $viewModel.currentModifiableTraitType
        )
        
        ConditionalSpacer(!viewModel.isExpanded || viewModel.mode != .creating)
        
        if !viewModel.isExpanded {
          Group {
            CreateCoachmarks(viewModel: viewModel)
            ConditionalSpacer(!viewModel.isExpanded || viewModel.mode != .creating)
          }
        }
        
        if viewModel.mode != .done {
          TraitTypePicker(
            viewModel: viewModel,
            animation: nsTraitPicker
          )
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
    }
    .addBottomSheet()
    .overlay {
      if viewModel.showConfetti && !viewModel.finishedConfetti {
        NounfettiView()
          .zIndex(100)
          .ignoresSafeArea()
          .allowsHitTesting(false)
      }
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
      viewModel.onShake()

      viewModel.showAllTraits()

      withAnimation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0)) {
        viewModel.randomizeNoun()
      }
      
      withAnimation(.spring().delay(3.0)) {
        viewModel.hideAllTraits()
      }
    }
    .onAppear {
      viewModel.onAppear()
      viewModel.showCoachmarkGuide()
    }
  }
}
