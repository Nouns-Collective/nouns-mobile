//
//  SlotMachine.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import UIComponents
import Services

extension NounPlayground {
  
  struct SlotMachine: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      ZStack(alignment: .bottom) {
        // An image of the shadow below the noun
        Image(R.image.shadow.name)
          .offset(y: 40)
          .padding(.horizontal, 20)
        
        ZStack(alignment: .top) {
          ForEach(ViewModel.TraitType.layeredOrder, id: \.rawValue) { type in
            Segment(
              viewModel: viewModel,
              type: type
            )
          }
        }
        .frame(maxWidth: .infinity, maxHeight: viewModel.imageSize)
      }
    }
  }
}
