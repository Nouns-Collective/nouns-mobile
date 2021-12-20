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
      
      return VStack(spacing: 3) {
        
        // Control to expand or fold `PickerTrait`.
        Image.chevronDown
          .rotationEffect(.degrees(isExpanded ? 180 : 0))
          .onTapGesture {
            withAnimation {
              isExpanded.toggle()
            }
          }
        
        VStack(spacing: 0) {
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
      }
    }
  }
}

struct TraitPickerItem: View {
  let image: String
  
  init(image: String) {
    self.image = image
  }
  
  var body: some View {
    Image(nounTraitName: image)
      .interpolation(.none)
      .resizable()
      .frame(width: 72, height: 72, alignment: .top)
      .background(Color.componentSoftGrey)
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }
  
  func selected(_ condition: Bool) -> some View {
    if condition {
      return AnyView(modifier(TraitSelectedModifier()))
    } else {
      return AnyView(self)
    }
  }
}

struct TraitSelectedModifier: ViewModifier {

  func body(content: Content) -> some View {
    content
      .background(Color.black.opacity(0.05))
      .overlay {
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color.componentNounsBlack, lineWidth: 2)
      }
  }
}
