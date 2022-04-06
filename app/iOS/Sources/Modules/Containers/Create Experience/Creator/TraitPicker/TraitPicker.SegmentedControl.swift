//
//  TraitPicker.SegmentedControl.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-24.
//

import SwiftUI
import UIComponents

extension NounCreator {
  
  struct TraitTypeSegmentedControl: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var selectedTraitType: Int
    
    @Namespace private var typeSelectionNamespace
    
    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) { proxy in
        // Displays all Noun's trait types in a segement control.
        OutlinePicker(selection: $selectedTraitType) {
          ForEach(TraitType.allCases, id: \.rawValue) { type in
            Text(type.description)
              .id(type.rawValue)
              .scrollId(type.rawValue)
              .pickerItemTag(type.rawValue, namespace: typeSelectionNamespace)
              .simultaneousGesture(
                TapGesture()
                  .onEnded { _ in
                    viewModel.didTapTraitType(to: .init(rawValue: type.rawValue) ?? .glasses)
                  }
              )
          }
        }
        .padding(.horizontal)
        .onChange(of: selectedTraitType) { newValue in
          withAnimation {
            proxy.scrollTo(newValue, alignment: .center, animated: true)
          }
        }
      }
    }
  }
}
