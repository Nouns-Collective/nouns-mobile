//
//  TraitPicker.swift
//  Nouns
//
//  Created by Ziad Tamim on 24.11.21.
//

import SwiftUI
import UIComponents
import Services

struct TraitPicker: View {
  @State var selection: Int = 0
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    VStack(spacing: 3) {
      Image.chevronDown
      
      PickerTabView(selection: $selection) {
        
        TraitCollection(items: AppCore.shared.nounComposer.glasses)
          .pickerTabItem("Glasses", tag: 0)
        
        TraitCollection(items: AppCore.shared.nounComposer.heads)
          .pickerTabItem("Head", tag: 1)
        
        TraitCollection(items: AppCore.shared.nounComposer.bodies)
          .pickerTabItem("Body", tag: 2)
        
        TraitCollection(items: AppCore.shared.nounComposer.accessories)
          .pickerTabItem("Accessory", tag: 3)
      }
    }
  }
}

struct TraitCollection: View {
  let items: [Trait]
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: rowSpec) {
        ForEach(0..<items.endIndex, id: \.self) { index in
          Image(nounTraitName: items[index].assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: 72, height: 72, alignment: .top)
        }
      }
      .padding(0)
    }
    .frame(maxHeight: 250)
  }
}

struct TraitPicker_Previews: PreviewProvider {
  static var previews: some View {
    Text("SlotMaching")
      .bottomSheet(isPresented: .constant(true)) {
        TraitPicker()
      }
  }
}
