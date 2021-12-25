//
//  TraitPicker.swift
//  Nouns
//
//  Created by Ziad Tamim on 24.11.21.
//

import SwiftUI
import UIComponents
import Services

extension NounPlayground {
  
  struct TraitTypePicker: View {
    @ObservedObject var viewModel: ViewModel
    let animation: Namespace.ID
    
    @State private var isExpanded = false
    @Namespace private var typeSelectionNamespace
    
    private let rowSpec = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]
    
    var body: some View {
      // TODO: - Delete once Picker accepts types that conform to `Hashable`.
      let selectionTraitType = Binding(
        get: { viewModel.currentModifiableTraitType.rawValue },
        set: { viewModel.currentModifiableTraitType = ViewModel.TraitType(rawValue: $0) ?? .head }
      )
      
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
          
          ScrollView(.horizontal, showsIndicators: false) {
            
            // Displays all Noun's trait types in a segement control.
            OutlinePicker(selection: selectionTraitType) {
              ForEach(ViewModel.TraitType.allCases, id: \.rawValue) { type in
                Text(type.description)
                  .id(type.rawValue)
                  .pickerItemTag(type.rawValue, namespace: typeSelectionNamespace)
              }
            }
            .padding(.horizontal)
          }
          
          // Expand or Fold the collection of Noun's Traits.
          if isExpanded {
            TraitTypeGrid(viewModel: viewModel)
          }
        }
        .padding(.bottom, 4)
      }
      .padding(isExpanded ? 12 : 0)
    }
  }
}
