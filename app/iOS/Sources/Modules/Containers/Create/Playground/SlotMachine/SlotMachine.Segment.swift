//
//  SlotMachine.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI

extension NounPlayground.SlotMachine {

  struct Segment: View {
    @ObservedObject var viewModel: NounPlayground.ViewModel
    let type: NounPlayground.ViewModel.TraitType
    
    @GestureState private var offset: CGFloat = 0
    
    public var body: some View {
      GeometryReader { proxy in
        LazyHStack(spacing: 0) {
          ForEach(type.traits, id: \.self) { trait in
            
            // Displays Noun's Trait Image.
            Image(nounTraitName: trait.assetImage)
              .interpolation(.none)
              .resizable()
              .frame(
                width: CGFloat(viewModel.imageSize),
                height: CGFloat(viewModel.imageSize)
              )
          }
        }
        .padding(.horizontal, proxy.size.width * 0.10)
        .offset(x: viewModel.traitOffset(for: type))
        .gesture(onDrag)
        .allowsHitTesting(viewModel.isDraggingEnabled(for: type))
        .animation(.easeInOut, value: offset == 0)
      }
    }
    
    /// Handles Drag Gesture to navigate across different `Noun's Traits`.
    private var onDrag: some Gesture {
      DragGesture()
        .updating($offset, body: { value, state, _ in
          state = value.translation.width
        })
        .onEnded({ value in
          let offsetX = value.translation.width
          viewModel.selectTrait(at: offsetX)
        })
    }
  }
}
