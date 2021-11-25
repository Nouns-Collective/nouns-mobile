//
//  TraitPicker.swift
//  Nouns
//
//  Created by Ziad Tamim on 24.11.21.
//

import SwiftUI
import UIComponents
import Services

// swiftlint:disable all
struct TraitPicker: View {
  @Namespace var slideActiveTabSpace
  var animation: Namespace.ID
  
  @State var anchor: Int = 0
    
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  @StateObject var model = TraitCollectionModel()
  
  init(animation: Namespace.ID) {
    self.animation = animation
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
      
      TraitCollection(model: model, anchor: $anchor)
    }
  }
}

struct TraitCollectionSection<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
  let tag: Int
  let items: Data
  private let content: (Data.Element, Data.Index) -> Content
  
  var selected: Data.Element?
    
  init(tag: Int, items: Data, @ViewBuilder cell: @escaping (_ item: Data.Element, _ index: Data.Index) -> Content) {
    self.tag = tag
    self.items = items
    self.content = cell
  }
  
  var body: some View {
    ForEach(0..<items.count, id: \.self) { index in
      content(items[index as! Data.Index], index as! Data.Index)
    }
  }
}

class TraitCollectionModel: NSObject, ObservableObject {
  
  @Published var selectedGlasses: Trait?
  @Published var selectedHead: Trait?
  @Published var selectedBody: Trait?
  @Published var selectedAccessory: Trait?
  @Published var selectedBackground: [Color]?
  
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
        LazyHGrid(rows: rowSpec, spacing: 4) {
          Section {
            TraitCollectionSection(tag: 0, items: AppCore.shared.nounComposer.glasses) { item, index in
              TraitPickerItem(image: item.assetImage)
                .selected(model.selectedGlasses == item)
                .id("0-\(index)")
                .onTapGesture {
                  withAnimation {
                    model.selectedGlasses = item
                  }
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
          }
                    
          Section {
            TraitCollectionSection(tag: 1, items: AppCore.shared.nounComposer.heads) { item, index in
              TraitPickerItem(image: item.assetImage, offset: CGSize(width: 0, height: 5))
                .selected(model.selectedHead == item)
                .id("1-\(index)")
                .onTapGesture {
                  withAnimation {
                    model.selectedHead = item
                  }
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
          }
          
          Section {
            TraitCollectionSection(tag: 2, items: AppCore.shared.nounComposer.bodies) { item, index in
              TraitPickerItem(image: item.assetImage, offset: CGSize(width: 0, height: -20))
                .selected(model.selectedBody == item)
                .id("2-\(index)")
                .onTapGesture {
                  withAnimation {
                    model.selectedBody = item
                  }
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
          }
                    
          Section {
            TraitCollectionSection(tag: 3, items: AppCore.shared.nounComposer.accessories) { item, index in
              TraitPickerItem(image: item.assetImage, offset: CGSize(width: 0, height: -20))
                .selected(model.selectedAccessory == item)
                .id("3-\(index)")
                .onTapGesture {
                  withAnimation {
                    model.selectedAccessory = item
                  }
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
          }
                    
          Section {
            TraitCollectionSection(tag: 4, items: Gradient.allGradients()) { gradient, index in
              GradientPickerItem(colors: gradient)
                .selected(model.selectedBackground == gradient)
                .id("4-\(index)")
                .onTapGesture {
                  withAnimation {
                    model.selectedBackground = gradient
                  }
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
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

struct GradientPickerItem: View {
  
  let colors: [Color]
  
  var body: some View {
    LinearGradient(
        colors: colors,
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
      .frame(width: 72, height: 72, alignment: .top)
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

extension GradientPickerItem {
  
  func selected(_ condition: Bool) -> some View {
    if condition {
      return AnyView(modifier(GradientSelectedModifier()))
    } else {
      return AnyView(self)
    }
  }
}

struct GradientSelectedModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(Color.black.opacity(0.05))
      .overlay {
        ZStack {
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.componentNounsBlack, lineWidth: 2)
          Image.checkmark
        }
      }
  }
}

struct TraitPickerItem: View {
  
  let image: String
  
  let offset: CGSize
  
  init(image: String, offset: CGSize = .zero) {
    self.image = image
    self.offset = offset
  }
  
  var body: some View {
    Image(nounTraitName: image)
      .interpolation(.none)
      .resizable()
      .frame(width: 72, height: 72, alignment: .top)
      .offset(offset)
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
