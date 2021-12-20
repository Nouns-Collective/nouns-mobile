//
//  NounPlayground.Output.swift
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
        Image(R.image.shadow.name)
          .offset(y: 40)
          .padding(.horizontal, 20)
        
        ZStack(alignment: .top) {
          ForEach(ViewModel.TraitType.allCases, id: \.rawValue) { type in
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
