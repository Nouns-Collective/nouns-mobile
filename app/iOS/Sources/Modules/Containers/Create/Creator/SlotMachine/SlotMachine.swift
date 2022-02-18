//
//  SlotMachine.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import UIComponents

struct SlotMachine: View {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
          withAnimation {
            self.viewModel.showAllTraits = false
          }
        }
      }
    }
  }
}
