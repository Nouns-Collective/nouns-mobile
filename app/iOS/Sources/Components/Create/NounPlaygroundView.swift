//
//  NounPlaygroundView.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounPlaygroundView: View {
  private let traits = [
    AppCore.shared.nounComposer.heads,
    AppCore.shared.nounComposer.glasses,
    AppCore.shared.nounComposer.bodies,
    AppCore.shared.nounComposer.accessories,
  ]
  
  @State var selectedTraitIndex = 0
  
  var body: some View {
    ZStack(alignment: .top) {
      ForEach(traits.indices) { index in
        SlotMachine(
          items: traits[index],
          isActive: selectedTraitIndex == index)
      }
    }
    .softNavigationTitle(R.string.create.title())
    .background(Gradient.freshMint)
    .ignoresSafeArea()
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
      let width = proxy.size.width
      
      LazyHStack(spacing: 0) {
        ForEach(0..<numberOfVisiableItems) { index in
          
          Image(nounTraitName: items[index].assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: width * 0.7, height: width * 0.7)
        }
      }
      .padding(.horizontal, 20)
      .offset(x: (CGFloat(index) * (-width * 0.7)) + offset)
      .gesture(
        DragGesture()
          .updating($offset, body: { value, state, _ in
            state = value.translation.width
          })
          .onEnded({ value in
            let offsetX = value.translation.width
            let progress = -offsetX / (width * 0.7)
            let roundIndex = progress.rounded()
            index = max(min(index + Int(roundIndex), items.count - 1), 0)
          })
      )
      .allowsHitTesting(isActive)
      .animation(.easeInOut, value: offset == 0)
    }
  }
}

struct NounPlaygroundView_Previews: PreviewProvider {
  static var previews: some View {
    NounPlaygroundView()
  }
}
