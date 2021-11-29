//
//  TraitPicker.swift
//  Nouns
//
//  Created by Ziad Tamim on 24.11.21.
//

import SwiftUI
import UIComponents
import Services

// TODO: Rebuild the TraitPicker & Use the view state in redux to keep the current noun's traits selections.
class TraitCollectionModel: NSObject, ObservableObject {
  @Published var selectedGlasses: Trait?
  @Published var selectedHead: Trait?
  @Published var selectedBody: Trait?
  @Published var selectedAccessory: Trait?
  @Published var selectedBackground: [Color]?
}

// swiftlint:disable all
struct TraitPicker: View {
  @Namespace var slideActiveTabSpace
  var animation: Namespace.ID
  @Binding var isPresented: Bool
  //  @Binding var selectedTraitType: Int
  @ObservedObject var viewModel: PlaygroundViewModel
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  @StateObject var model = TraitCollectionModel()
  
  init(isPresented: Binding<Bool>, animation: Namespace.ID, viewModel: PlaygroundViewModel) {
    self.animation = animation
    self.viewModel = viewModel
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
      
      ScrollView(.horizontal, showsIndicators: false) {
        OutlinePicker(selection: $viewModel.selectedTraitType) {
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
      
      if isPresented {
        TraitGrid(
          model: model,
          viewModel: viewModel)
      }
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
    Section {
      ForEach(0..<items.count, id: \.self) { index in
        content(items[index as! Data.Index], index as! Data.Index)
      }
    }
  }
}

struct TraitGrid: View {
  @ObservedObject var model: TraitCollectionModel
  @ObservedObject var viewModel: PlaygroundViewModel
  
  private let rowSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: rowSpec, spacing: 4) {
          TraitCollectionSection(tag: 0, items: AppCore.shared.nounComposer.glasses) { item, index in
            TraitPickerItem(image: item.assetImage)
              .selected(viewModel.seed[0] == index)
              .id("0-\(index)")
              .onTapGesture {
                withAnimation {
                  model.selectedGlasses = item
                  viewModel.seed[0] = index
                }
              }
              .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
          }
          
          TraitCollectionSection(tag: 1, items: AppCore.shared.nounComposer.heads) { item, index in
            TraitPickerItem(image: item.assetImage)
              .selected(viewModel.seed[1] == index)
              .id("1-\(index)")
              .onTapGesture {
                withAnimation {
                  model.selectedHead = item
                  viewModel.seed[1] = index
                }
              }
              .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
          }
          
          TraitCollectionSection(tag: 2, items: AppCore.shared.nounComposer.bodies) { item, index in
            TraitPickerItem(image: item.assetImage)
              .selected(viewModel.seed[2] == index)
              .id("2-\(index)")
              .onTapGesture {
                withAnimation {
                  model.selectedBody = item
                  viewModel.seed[2] = index
                }
              }
              .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
          }
          
          TraitCollectionSection(tag: 3, items: AppCore.shared.nounComposer.accessories) { item, index in
            TraitPickerItem(image: item.assetImage)
              .selected(viewModel.seed[3] == index)
              .id("3-\(index)")
              .onTapGesture {
                withAnimation {
                  model.selectedAccessory = item
                  viewModel.seed[3] = index
                }
              }
              .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
          }
          
          TraitCollectionSection(tag: 4, items: Gradient.allGradients()) { gradient, index in
            GradientPickerItem(colors: gradient)
              .selected(viewModel.seed[4] == index)
              .id("4-\(index)")
              .onTapGesture {
                withAnimation {
                  model.selectedBackground = gradient
                  viewModel.seed[4] = index
                }
              }
              .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
          }
        }
        .onChange(of: viewModel.selectedTraitType, perform: { newSelectedTrait in
          withAnimation {
            proxy.scrollTo("\(newSelectedTrait)-\(viewModel.seed[newSelectedTrait])", anchor: .leading)
          }
        })
        .onChange(of: viewModel.seed, perform: { seed in
//          withAnimation {
//            proxy.scrollTo("\(viewModel.selectedTraitType)-\(seed[viewModel.selectedTraitType])", anchor: .center)
//          }
        })
        .padding(.vertical)
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

//struct TraitPicker_Previews: PreviewProvider {
//
//  struct Preview: View {
//    @State var isPresented = true
//
//    @State var selection: Int = 0
//
//    @Namespace var ns
//
//    var body: some View {
//      VStack {
//        Button("Show") {
//          withAnimation {
//            isPresented.toggle()
//          }
//        }
//      }
//      .bottomSheet(isPresented: $isPresented) {
//        TraitPicker(animation: ns, selectedTraitType: .constant(1))
//      }
//    }
//  }
//
//  static var previews: some View {
//    Preview()
//  }
//}
