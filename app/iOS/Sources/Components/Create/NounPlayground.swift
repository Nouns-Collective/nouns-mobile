//
//  NounPlaygroundView.swift
//  Nouns
//
//  Created by Ziad Tamim on 22.11.21.
//

import SwiftUI
import UIComponents
import Services

// TODO: Rebuild the Playground & Use the view state in redux to keep the current noun's traits selections.
class PlaygroundViewModel: ObservableObject {
  @Published var selectedTraitType = 0
  @Published var seed: [Int] = [
    0, // glasses
    0, // head
    0, // body
    0, // accessory
    0  // background
  ]
  
  @Published var name: String = ""
}

struct NounPlayground: View {
  @State private var isCreationPresented = false
  @State private var isTraitPickerPresented = false
  @State private var isWillingToClose = false
  @Namespace private var namespace
  
  @StateObject private var viewModel = PlaygroundViewModel()
  
  /// Traits displayed in the same order as the trait picker
  private let traits = [
    AppCore.shared.nounComposer.glasses,
    AppCore.shared.nounComposer.heads,
    AppCore.shared.nounComposer.bodies,
    AppCore.shared.nounComposer.accessories,
  ]
  
  private let zIndex: [Double] = [4, 3, 1, 2]
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      ZStack(alignment: .bottom) {
        Image(R.image.shadow.name)
          .offset(y: 40)
          .padding(.horizontal, 20)
        
        ZStack(alignment: .top) {
          ForEach(traits.indices) { tag in
            SlotMachine(
              items: traits[tag],
              typeTag: tag,
              viewModel: viewModel)
              .zIndex(zIndex[tag])
          }
        }
        .frame(maxWidth: .infinity, maxHeight: 320)
      }
      
      Spacer()
      
      if isTraitPickerPresented {
        PlainCell {
          TraitPicker(
            isPresented: $isTraitPickerPresented,
            animation: namespace,
            viewModel: viewModel)
        }
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom))
        
      } else {
        TraitPicker(
          isPresented: $isTraitPickerPresented,
          animation: namespace,
          viewModel: viewModel)
          .padding(.bottom, 20)
          .transition(
            AnyTransition.asymmetric(
              insertion: AnyTransition.opacity.animation(Animation.default.delay(0.2)),
              removal: AnyTransition.move(edge: .bottom))
          )
      }
    }
    // Resuable component to close & back buttons...
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: {
          withAnimation {
            isWillingToClose.toggle()
          }
        })
      
    }, rightAccessory: {
      SoftButton(
        text: "Done",
        smallAccessory: { Image.checkmark },
        action: {
          withAnimation {
            isCreationPresented.toggle()
            isTraitPickerPresented = false
          }
        })
    })
    .background(LinearGradient(
      colors: Gradient.allGradients()[viewModel.seed[4]],
      startPoint: .topLeading,
      endPoint: .bottomTrailing))
    .bottomSheet(isPresented: $isWillingToClose) {
      DeleteOfflineNounDialog(isDisplayed: $isWillingToClose)
    }
    .bottomSheet(isPresented: $isCreationPresented) {
      NounMetadataDialog(
        viewModel: viewModel,
        isEditing: .constant(true),
        isPresented: $isCreationPresented)
    }
  }
}

public struct SlotMachine: View {
  public let items: [Trait]
  let typeTag: Int
  @ObservedObject var viewModel: PlaygroundViewModel
  @GestureState private var offset: CGFloat = 0
  
  private var isActive: Bool {
    viewModel.selectedTraitType == typeTag
  }
  
  var numberOfVisibleItems: Int {
    items.endIndex
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let traitWidth: CGFloat = 320
      
      LazyHStack(spacing: 0) {
        ForEach(0..<numberOfVisibleItems, id: \.self) { index in
          Image(nounTraitName: items[index].assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: traitWidth, height: traitWidth)
        }
      }
      .padding(.horizontal, proxy.size.width * 0.10)
      .offset(x: isActive ? ((CGFloat(viewModel.seed[typeTag]) * -traitWidth) + offset) : (CGFloat(viewModel.seed[typeTag]) * -traitWidth))
      .gesture(
        DragGesture()
          .updating($offset, body: { value, state, _ in
            state = value.translation.width
          })
          .onEnded({ value in
            let offsetX = value.translation.width
            let progress = -offsetX / traitWidth
            let roundIndex = progress.rounded()
            viewModel.seed[typeTag] = max(min(viewModel.seed[typeTag] + Int(roundIndex), items.endIndex - 1), 0)
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
