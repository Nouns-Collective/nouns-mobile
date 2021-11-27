//
//  NounPlaygroundView.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents
import Services

struct PlaygroundMachine: View {
  @Binding var isPresented: Bool
  
  private let traits = [
    AppCore.shared.nounComposer.bodies,
    AppCore.shared.nounComposer.heads,
    AppCore.shared.nounComposer.glasses,
    AppCore.shared.nounComposer.accessories,
  ]
  
  @State var selectedTraitIndex = 1
  
  var body: some View {
    VStack {
      ZStack(alignment: .top) {
        ForEach(traits.indices) { index in
          SlotMachine(
            items: traits[index],
            isActive: selectedTraitIndex == index)
        }
      }
      
      Image(R.image.shadow.name)
    }
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { isPresented.toggle() })
      
    }, rightAccessory: {
      SoftButton(
        text: "Done",
        smallAccessory: { Image.checkmark },
        action: {
        })
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
  
  var numberOfVisiableItems: Int {
    isActive ? items.endIndex : 1
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let traitWidth = proxy.size.width * 0.6
      
      LazyHStack(spacing: 0) {
        ForEach(0..<numberOfVisiableItems) { index in
          Image(nounTraitName: items[index].assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: traitWidth, height: traitWidth)
        }
      }
      .padding(.horizontal, proxy.size.width * 0.18)
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
    PlaygroundMachine(isPresented: .constant(true))
  }
}
