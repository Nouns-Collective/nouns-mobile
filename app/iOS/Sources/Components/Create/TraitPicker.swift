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
  var animation: Namespace.ID
  
  @State var selection: Int = 0
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    VStack(spacing: 3) {
      Image.chevronDown
      
      PickerTabView(animation: animation, scrollable: true, selection: $selection) {
        
        TraitCollection(items: AppCore.shared.nounComposer.glasses)
          .pickerTabItem("Glasses", tag: 0)
        
        TraitCollection(items: AppCore.shared.nounComposer.heads)
          .pickerTabItem("Head", tag: 1)
        
        TraitCollection(items: AppCore.shared.nounComposer.bodies)
          .pickerTabItem("Body", tag: 2)
        
        TraitCollection(items: AppCore.shared.nounComposer.accessories)
          .pickerTabItem("Accessory", tag: 3)
        
        TraitCollection(items: AppCore.shared.nounComposer.accessories)
          .pickerTabItem("Background", tag: 4)
      }
    }
  }
}

struct TraitCollection: View {
  let items: [Trait]
  
  @State private var selectedItem: String?
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: rowSpec) {
        ForEach(0..<items.endIndex, id: \.self) { index in
          TraitPickerItem(image: items[index].assetImage)
            .selected(selectedItem == items[index].assetImage)
            .onTapGesture {
              withAnimation {
                selectedItem = items[index].assetImage
              }
            }
        }
      }
      .padding(.horizontal)
      .padding(.bottom)
      .padding(.top)
    }
    .frame(maxHeight: 250)
  }
}

struct TraitPickerItem: View {
  
  let image: String
  
  var body: some View {
    Image(nounTraitName: image)
      .interpolation(.none)
      .resizable()
      .frame(width: 72, height: 72, alignment: .top)
      .tag(image)
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

struct TraitPicker_Previews: PreviewProvider {
  
  struct Preview: View {
    @State var isPresented = true
    
    @State var selection: Int = 0
    
    @Namespace var ns
    
    var body: some View {
      VStack {
        Text("Slot Machine")
        Button("Show") {
          withAnimation {
            isPresented.toggle()
          }
        }
      }
      .bottomSheet(isPresented: $isPresented) {
        TraitPicker(animation: ns)
      }
    }
  }
  
  static var previews: some View {
    Preview()
  }
}
