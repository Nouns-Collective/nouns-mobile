//
//  SlotMachine.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI

extension SlotMachine {

  struct Segment: View {
    @ObservedObject var viewModel: ViewModel
    let type: ViewModel.TraitType
    
    @GestureState private var offset: CGFloat = 0
    
    /// A utility function to determine the opacity of the trait images
    /// If the type is currently selected (e.g. head) then all traits should be shown which may include images on the left or right of the main centered trait.
    /// If the type is NOT selected, then it should only show the trait that is currently selected in the centre and none on the sides.
    private func opacity(forIndex index: Int) -> Double {
      guard !viewModel.showAllTraits else { return 1 }
      
      if viewModel.currentModifiableTraitType == type {
        return 1
      } else {
        return viewModel.isSelected(index, traitType: type) ? 1 : 0
      }
    }
    
    public var body: some View {
      GeometryReader { proxy in
        LazyHStack(spacing: 0) {
          ForEach(0..<type.traits.count, id: \.self) { index in
            
            // Displays Noun's Trait Image.
            Image(nounTraitName: type.traits[index].assetImage)
              .interpolation(.none)
              .resizable()
              .frame(
                width: CGFloat(viewModel.imageSize),
                height: CGFloat(viewModel.imageSize)
              )
              .opacity(opacity(forIndex: index))
          }
        }
        .padding(.horizontal, proxy.size.width * 0.10)
        .offset(x: viewModel.traitOffset(for: type, by: offset))
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
