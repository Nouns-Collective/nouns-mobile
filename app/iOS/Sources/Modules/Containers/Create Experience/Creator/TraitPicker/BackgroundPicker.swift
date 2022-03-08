//
//  BackgroundPicker.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-03-07.
//

import SwiftUI
import UIComponents

extension NounCreator {
  
  /// Similar to the `Segment` view, the background picker is an extension to the noun creator
  /// which allows users to swipe left and right between different background colors/gradients
  struct BackgroundPicker: View {
    @ObservedObject var viewModel: ViewModel
    
    @GestureState private var offset: CGFloat = 0
    
    static let width: CGFloat = UIScreen.main.bounds.width

    var body: some View {
      LazyHStack(spacing: 0) {
        ForEach(0..<NounCreator.backgroundColors.count, id: \.self) { index in
          Gradient(colors: NounCreator.backgroundColors[index].colors)
            .frame(maxHeight: .infinity)
            .frame(width: BackgroundPicker.width)
        }
      }
      .frame(width: BackgroundPicker.width, alignment: .leading)
      .frame(maxHeight: .infinity)
      .offset(x: viewModel.backgroundOffset(width: BackgroundPicker.width, offset: offset))
      .gesture(onDrag)
      .animation(.easeInOut, value: offset == 0)
      .allowsHitTesting(viewModel.currentModifiableTraitType == .background)
    }
    
    /// Handles Drag Gesture to navigate across different `Noun's Traits`.
    private var onDrag: some Gesture {
      DragGesture()
        .updating($offset, body: { value, state, _ in
          state = value.translation.width
        })
        .onEnded({ value in
          // A negative horizontal direction is a gesture starting from the right of the screen towards the left
          // A positive horizontal direction is a gesture starting from the left of the screen towards the right
          let horizontalDirection = value.predictedEndLocation.x - value.location.x
          
          viewModel.selectBackground(direction: horizontalDirection)
        })
    }
  }
}
