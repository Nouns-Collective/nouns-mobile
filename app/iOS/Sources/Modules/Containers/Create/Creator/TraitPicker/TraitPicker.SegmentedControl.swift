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
      ScrollViewReader { proxy in
        
        ScrollView(.horizontal, showsIndicators: false) {
          
          // Displays all Noun's trait types in a segement control.
          OutlinePicker(selection: $selectedTraitType) {
            ForEach(ViewModel.TraitType.allCases, id: \.rawValue) { type in
              Text(type.description)
                .id(type.rawValue)
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
          // TODO: - This currently creates breaking UI issues (https://github.com/secretmissionsoftware/nouns-ios/issues/288)
          /*
          .onChange(of: selectedTraitType) { newValue in
            withAnimation {
              proxy.scrollTo(newValue, anchor: .center)
            }
          }
           */
        }
      }
    }
  }
}
