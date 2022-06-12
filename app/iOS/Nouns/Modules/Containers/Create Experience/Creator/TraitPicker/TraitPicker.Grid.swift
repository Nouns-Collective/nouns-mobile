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
import Combine
import NounsUI

struct ViewOffsetKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue = CGFloat.zero
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value += nextValue()
  }
}

extension NounCreator {
  
  struct TraitTypeGrid: View {
    @ObservedObject var viewModel: ViewModel
    
    private let rowSpec = [
      GridItem(.flexible(), spacing: 4),
      GridItem(.flexible(), spacing: 4),
      GridItem(.flexible(), spacing: 4),
    ]
    
    /// Returns the `id` of the very first trait in a given trait type
    private func traitFirstIndexID(_ trait: TraitType) -> String {
      return "\(trait.rawValue)-0"
    }
    
    /// Returns the `id` of the currently selected trait, which is based on which trait type is currently selected from the tab picker
    private var currentlySelectedTraitID: String {
      return "\(viewModel.currentModifiableTraitType.rawValue)-\(viewModel.selectedTrait(forType: viewModel.currentModifiableTraitType))"
    }
    
    var body: some View {
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHGrid(rows: rowSpec, spacing: 4) {
            
            // Trait selection
            ForEach(TraitType.allCases, id: \.rawValue) { type in
              
              TraitCollectionSection(type: type, items: type.traits) { trait, index in
                TraitPickerItem(image: trait.assetImage)
                  .selected(viewModel.isSelected(index, traitType: type))
                  .onTapGesture {
                    withAnimation(.easeInOut) {
                      viewModel.selectTrait(index, ofType: type)
                    }
                  }
                  .id("\(type.rawValue)-\(index)")
                // This applies a padding to only the first column (rowSpec.count) of items to distinguish the different trait sections
                  .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
              }
              .onAppear {
                viewModel.traitSectionDidAppear(type)
              }
              .onDisappear {
                viewModel.traitSectionDidDisappear(type)
              }
            }
            
            // Gradient background selection
            TraitCollectionSection(type: .background, items: NounCreator.backgroundColors) { gradient, index in
              
              GradientPickerItem(colors: gradient.colors)
                .selected(viewModel.isSelected(index, traitType: .background))
                .onTapGesture {
                  viewModel.selectTrait(index, ofType: .background)
                }
                .id("\(TraitType.background.rawValue)-\(index)")
              // This applies a padding to only the first column (rowSpec.count)
              // of items to distinguish the different trait sections
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
            .onAppear {
              viewModel.traitSectionDidAppear(.background)
            }
            .onDisappear {
              viewModel.traitSectionDidDisappear(.background)
            }
          }
          .padding(.vertical, 12)
          .padding(.trailing)
          .onAppear {
            // Scroll to the currently selected trait type first
            //
            // Without this, the trait grid will show the first section (glasses)
            // which will invoke a `viewModel.traitSectionDidAppear(.glasses)`, thus
            // changing the selection back to glasses even if the user had previously selected
            // another section before the trait grid appeared
            proxy.scrollTo(traitFirstIndexID(viewModel.currentModifiableTraitType), anchor: .leading)
          }
          .onReceive(viewModel.tapPublisher, perform: { newTrait in
            // Provides an animation to scroll to the first item of the newly selected trait (from the tab picker)
            withAnimation {
              proxy.scrollTo(traitFirstIndexID(newTrait), anchor: .leading)
            }
          })
          .onChange(of: viewModel.seed, perform: { _ in
            withAnimation {
              // Provides an animation on the grid to always scroll to the center of the currently selected trait
              proxy.scrollTo(currentlySelectedTraitID, anchor: .center)
            }
          })
        }
        .frame(maxHeight: 250)
      }
    }
  }
}
