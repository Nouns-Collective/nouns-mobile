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
  @Namespace var slideActiveTabSpace
  var animation: Namespace.ID
  
  @State var anchor: Int = 0
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var sections: [TraitCollectionSection] {
    let glasses = TraitCollectionSection(tag: 0, items: AppCore.shared.nounComposer.glasses)
    let heads = TraitCollectionSection(tag: 1, items: AppCore.shared.nounComposer.heads)
    let bodies = TraitCollectionSection(tag: 2, items: AppCore.shared.nounComposer.bodies)
    let accessories = TraitCollectionSection(tag: 3, items: AppCore.shared.nounComposer.accessories)
    let backgrounds = TraitCollectionSection(tag: 4, items: AppCore.shared.nounComposer.accessories)
    
    return [glasses, heads, bodies, accessories, backgrounds]
  }
  
  var body: some View {
    VStack(spacing: 3) {
      Image.chevronDown
      
      ScrollView(.horizontal, showsIndicators: false) {
        OutlinePicker(selection: $anchor) {
          Text("Glasses")
            .id(0)
            .pickerItemTag(0, namespace: slideActiveTabSpace)
          
          Text("Head")
            .id(1)
            .pickerItemTag(1, namespace: slideActiveTabSpace)
          
          Text("Body")
            .id(2)
            .pickerItemTag(2, namespace: slideActiveTabSpace)
          
          Text("Accessory")
            .id(3)
            .pickerItemTag(3, namespace: slideActiveTabSpace)
          
          Text("Background")
            .id(4)
            .pickerItemTag(4, namespace: slideActiveTabSpace)
        }
        .padding(.horizontal)
      }
      
      TraitCollection(model: TraitCollectionModel(sections: sections), anchor: $anchor)
    }
  }
}

struct TraitCollectionSection {
  let tag: Int
  let items: [Trait]
  
  var selected: Trait?
  
  init(tag: Int, items: [Trait]) {
    self.tag = tag
    self.items = items
  }
}

class TraitCollectionModel: NSObject, ObservableObject {
  @Published var sections: [TraitCollectionSection]
  
  init(sections: [TraitCollectionSection]) {
    self.sections = sections
  }
}

struct TraitCollection: View {
  @ObservedObject var model: TraitCollectionModel
  
  @Binding var anchor: Int
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: rowSpec) {
          ForEach(0..<model.sections.endIndex, id: \.self) { sectionIndex in
            ForEach(0..<model.sections[sectionIndex].items.endIndex, id: \.self) { itemIndex in
              TraitPickerItem(image: model.sections[sectionIndex].items[itemIndex].assetImage)
                .selected(model.sections[sectionIndex].selected == model.sections[sectionIndex].items[itemIndex])
                .id("\(model.sections[sectionIndex].tag)-\(itemIndex)")
                .onTapGesture {
                  withAnimation {
                    model.sections[sectionIndex].selected = model.sections[sectionIndex].items[itemIndex]
                  }
                }
            }
          }
        }
        .onChange(of: anchor, perform: { [anchor] newAnchor in
          if anchor != newAnchor {
            withAnimation {
              proxy.scrollTo("\(newAnchor)-0", anchor: .leading)
            }
          }
        })
        .padding(.horizontal)
        .padding(.bottom)
        .padding(.top)
      }
      .frame(maxHeight: 250)
    }
  }
}

struct TraitPickerItem: View {
  
  let image: String
  
  var body: some View {
    Image(nounTraitName: image)
      .interpolation(.none)
      .resizable()
      .frame(width: 72, height: 72, alignment: .top)
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
