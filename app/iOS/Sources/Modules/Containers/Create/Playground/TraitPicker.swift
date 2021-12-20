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
  
  struct TraitPicker: View {
    @ObservedObject var viewModel: ViewModel
    
    @Namespace var slideActiveTabSpace
    var animation: Namespace.ID
    @Binding var isPresented: Bool
    
    private let rowSpec = [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]
    
    init(isPresented: Binding<Bool>, animation: Namespace.ID) {
      self.animation = animation
      self._isPresented = isPresented
    }
    
    var body: some View {
      VStack(spacing: 3) {
        Image.chevronDown
          .rotationEffect(.degrees(isPresented ? 180 : 0))
          .onTapGesture {
            withAnimation {
              isPresented.toggle()
            }
          }
        
        VStack(spacing: 0) {
          ScrollView(.horizontal, showsIndicators: false) {
            
            OutlinePicker(selection: viewModel.$currentModifiableTraitType) {
              ForEach(ViewModel.TraitType.allCases, id: \.rawValue) { type in
                Text(type.description)
                  .id(type.rawValue)
                  .pickerItemTag(type.rawValue, namespace: slideActiveTabSpace)
              }
            }
//            .onChange(of: selectedTraitType) { newValue in
              //              store.dispatch(PlaygroundUpdateSelectedTrait(trait: newValue))
//            }
            .padding(.horizontal)
          }
          
          if isPresented {
            TraitGrid()
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
}

extension TraitPickerItem {
  
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
