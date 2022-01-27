//
//  TraitPicker.swift
//  Nouns
//
//  Created by Ziad Tamim on 24.11.21.
//

import SwiftUI
import UIComponents
import Services

extension NounCreator {
  
  struct TraitTypePicker: View {
    @ObservedObject var viewModel: ViewModel
    let animation: Namespace.ID
    
    @Binding var isExpanded: Bool
    
    @State private var selectedTraitType: Int = ViewModel.TraitType.glasses.rawValue
    
    private let rowSpec = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]
    
    var body: some View {
      return PlainCell(
        background: isExpanded ? Color.white : nil,
        borderColor: isExpanded ? Color.black : nil
      ) {
        VStack(spacing: 0) {
          // Control to expand or fold `PickerTrait`.
          Image.chevronDown
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
            .onTapGesture {
              withAnimation {
                isExpanded.toggle()
              }
            }
            .padding(.vertical, 4)
          
          TraitTypeSegmentedControl(viewModel: viewModel, selectedTraitType: $selectedTraitType)
          
          // Expand or Fold the collection of Noun's Traits.
          if isExpanded {
            TraitTypeGrid(viewModel: viewModel)
          }
        }
        .padding(.bottom, 4)
      }
      .padding([.leading, .bottom, .trailing], isExpanded ? 12 : 0)
      .onChange(of: viewModel.currentModifiableTraitType) { newValue in
        // causing an infinite cycle
        if newValue.rawValue != selectedTraitType {
          selectedTraitType = newValue.rawValue
        }
      }
    }
  }
}
