// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
          let horizontalVelocity = value.predictedEndLocation.x - value.location.x
          viewModel.didScrollBackgroundPicker(withVelocity: horizontalVelocity)
        })
    }
  }
}
