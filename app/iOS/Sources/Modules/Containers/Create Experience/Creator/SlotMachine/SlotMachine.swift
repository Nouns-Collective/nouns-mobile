//
//  SlotMachine.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import UIComponents
import Services

struct SlotMachine: View {
  @Environment(\.initialSeed) var initialSeed: Seed
  
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    ZStack(alignment: .bottom) {
      // An image of the shadow below the noun
      Image(R.image.shadow.name)
        .offset(y: 40)
        .padding(.horizontal, 20)
        .hidden(!viewModel.showShadow)
      
      ZStack(alignment: .top) {
        ForEach(ViewModel.TraitType.layeredOrder, id: \.rawValue) { type in
          Segment(
            viewModel: viewModel,
            type: type
          )
        }
      }
      .frame(maxHeight: viewModel.imageSize)
    }
    .onAppear {
      // A small delay is needed so that all the animation logic
      // happens after the view is rendered in it's complete form
      // at least once. If the animation logic + the appearance of the
      // view happens at the same time, the entire view will animate
      // into place (including the navigation title and background)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
        // Animate the slot machine's seed if `animateEntrance` is
        // set to true. It will set the seed to something random,
        // show all the neighbouring traits for all trait types.
        // then animate the transition back to the original initial seed,
        // finally hiding all the neighbouring traits at the end
        if viewModel.animateEntrance {
          viewModel.randomizeSeed()
          viewModel.showAllTraits = true
          
          withAnimation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0)) {
            viewModel.resetToInitialSeed()
          }
          
          withAnimation(.spring().delay(3.0)) {
            self.viewModel.showAllTraits = false
          }
        }
      }
    }
    .onChange(of: initialSeed) { newValue in
      viewModel.initialSeed = newValue
    }
  }
}
