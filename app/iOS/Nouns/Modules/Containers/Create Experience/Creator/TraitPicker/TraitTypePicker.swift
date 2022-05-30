//
//  TraitPicker.swift
//  Nouns
//
//  Created by Ziad Tamim on 24.11.21.
//

import SwiftUI
import NounsUI
import Services

extension NounCreator {
  
  struct TraitTypePicker: View {
    @ObservedObject var viewModel: ViewModel
    let animation: Namespace.ID
    
    @State private var selectedTraitType: Int = TraitType.glasses.rawValue
    
    private let rowSpec = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]
    
    private func dragGesture() -> _EndedGesture<DragGesture> {
      DragGesture()
        .onEnded { value in
          let verticalDirection = value.predictedEndLocation.y - value.location.y
          
          if verticalDirection < 0 {
            // Swipe up
            withAnimation {
              viewModel.isExpanded = true
            }
          } else {
            // Swipe down
            withAnimation {
              viewModel.isExpanded = false
            }
          }
        }
    }
    
    var body: some View {
      PlainCell(
        background: viewModel.isExpanded ? Color.white : nil,
        borderColor: viewModel.isExpanded ? Color.black : Color.clear
      ) {
        VStack(spacing: 0) {
          VStack(spacing: 0) {
            // Control to expand or fold `TraitTypeGrid`.
            Image.chevronDown
              .rotationEffect(.degrees(viewModel.isExpanded ? 0 : 180))
              .onTapGesture {
                withAnimation {
                  viewModel.isExpanded.toggle()
                }
              }
              .padding(.vertical, 4)
            
            TraitTypeSegmentedControl(viewModel: viewModel, selectedTraitType: $selectedTraitType)
          }
          .gesture(dragGesture())
          
          // Expand or Fold the collection of Noun's Traits.
          if viewModel.isExpanded {
            TraitPickerUIKitView(viewModel: viewModel)
              .frame(height: 250)
              .padding(.vertical, 8)
          }
        }
        .padding(.bottom, 4)
      }
      .padding([.leading, .bottom, .trailing], viewModel.isExpanded ? 12 : 0)
      .onChange(of: viewModel.currentModifiableTraitType) { newValue in
        if newValue.rawValue != selectedTraitType {
          selectedTraitType = newValue.rawValue
        }
      }
    }
  }
}
