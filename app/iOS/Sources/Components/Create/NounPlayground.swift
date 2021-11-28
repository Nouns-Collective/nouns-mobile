//
//  NounPlaygroundView.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounPlayground: View {
  @Environment(\.presentationMode) private var presentationMode
  @State private var currentTraitTypeTag = 0
  @State private var isTraitPickerPresented = true
  @Namespace private var namespace
  
  /// Traits displayed in the same order as the trait picker
  private let traits = [
    AppCore.shared.nounComposer.glasses,
    AppCore.shared.nounComposer.heads,
    AppCore.shared.nounComposer.bodies,
    AppCore.shared.nounComposer.accessories,
  ]
  
  private let zIndex: [Double] = [4, 3, 1, 2]
  
  @State var selectedTraitIndex = 0
  
  var body: some View {
    VStack {
      Spacer()
      
      ZStack(alignment: .bottom) {
        Image(R.image.shadow.name)
          .offset(y: 40)
          .padding(.horizontal, 20)
        
        ZStack(alignment: .top) {
          ForEach(traits.indices) { index in
            SlotMachine(
              items: traits[index],
              isActive: selectedTraitIndex == index
            ).zIndex(zIndex[index])
          }
        }
        .frame(maxWidth: .infinity, maxHeight: 320)
      }
      
      Spacer()
      
      PlainCell {
        TraitPicker(animation: namespace, selectedTraitIndex: $selectedTraitIndex)
      }
      .padding(.horizontal, 20)
    }
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { presentationMode.wrappedValue.dismiss() })
      
    }, rightAccessory: {
      SoftButton(
        text: "Done",
        smallAccessory: { Image.checkmark },
        action: { })
    })
    .background(Gradient.orangesicle)
  }
}

struct SlotMachineBoundsKey: PreferenceKey {
  static var defaultValue: Anchor<CGRect>?
  
  static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
    value = value ?? nextValue()
  }
}

public struct SlotMachine: View {
  public let items: [Trait]
  public var isActive: Bool
  
  @GestureState private var offset: CGFloat = 0
  @State private var index = 0
  
  var numberOfVisibleItems: Int {
    isActive ? items.endIndex : 1
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let traitWidth: CGFloat = 320
      
      LazyHStack(spacing: 0) {
        ForEach(0..<numberOfVisibleItems) { index in
          Image(nounTraitName: items[index].assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: traitWidth, height: traitWidth)
        }
      }
      .padding(.horizontal, proxy.size.width * 0.10)
      .offset(x: (CGFloat(index) * -traitWidth) + offset)
      .gesture(
        DragGesture()
          .updating($offset, body: { value, state, _ in
            state = value.translation.width
          })
          .onEnded({ value in
            let offsetX = value.translation.width
            let progress = -offsetX / traitWidth
            let roundIndex = progress.rounded()
            index = max(min(index + Int(roundIndex), items.endIndex - 1), 0)
          })
      )
      .allowsHitTesting(isActive)
      .animation(.easeInOut, value: offset == 0)
    }
  }
}

struct NounPlaygroundView_Previews: PreviewProvider {
  static var previews: some View {
    NounPlayground()
  }
}
