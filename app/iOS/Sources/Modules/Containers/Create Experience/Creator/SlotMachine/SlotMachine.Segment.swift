//
//  SlotMachine.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import Services

extension SlotMachine {

  struct Segment: View {
    
    @GestureState private var dragOffset: CGFloat = 0
    
    @Binding var seed: Seed

    let type: TraitType
    
    let currentModifiableTraitType: TraitType
    
    let showAllTraits: Bool
    
    let imageWidth: Double
    
    /// A utility function to determine the opacity of the trait images
    /// If the type is currently selected (e.g. head) then all traits should be shown which may include images on the left or right of the main centered trait.
    /// If the type is NOT selected, then it should only show the trait that is currently selected in the centre and none on the sides.
    private func opacity(forIndex index: Int) -> Double {
      guard !showAllTraits else { return 1 }
      
      if currentModifiableTraitType == type {
        return 1
      } else {
        return isSelected(index, traitType: type) ? 1 : 0
      }
    }
    
    public var body: some View {
      GeometryReader { _ in
        LazyHStack(spacing: 0) {
          ForEach(0..<type.traits.count, id: \.self) { index in
            
            // Displays Noun's Trait Image.
            Image(nounTraitName: type.traits[index].assetImage)
              .interpolation(.none)
              .resizable()
              .frame(
                width: CGFloat(imageWidth),
                height: CGFloat(imageWidth)
              )
              .opacity(opacity(forIndex: index))
          }
        }
        .padding(.horizontal, (UIScreen.main.bounds.width - imageWidth) / 2)
        .offset(x: traitOffset(for: type, by: dragOffset))
        .gesture(onDrag)
        .allowsHitTesting(isDraggingEnabled(for: type))
        .animation(.easeInOut, value: dragOffset == 0)
      }
    }
    
    /// Handles Drag Gesture to navigate across different `Noun's Traits`.
    private var onDrag: some Gesture {
      DragGesture()
        .updating($dragOffset, body: { value, state, _ in
          state = value.translation.width
        })
        .onEnded({ value in
          // A negative horizontal velocity is a gesture starting from the right of the screen towards the left
          // A positive horizontal velocity is a gesture starting from the left of the screen towards the right
          let horizontalVelocity = value.predictedEndLocation.x - value.location.x
          didScroll(withVelocity: horizontalVelocity)
        })
    }
    
    /// Selecting a trait by swiping left or right on the noun
    func didScroll(withVelocity velocity: Double) {
      // Only allow swiping between traits if the difference between the predicted
      // gesture end location and the final drag location is greater than the scroll threshold.
      guard abs(velocity) >= 40 else { return }
      
      // If direction is negative, we should go to the next (right) trait
      // If direction is positive, we should go to the previous (left) trait
      let index: Int = velocity > 0 ? -1 : 1
      
      // Set Bounderies to not scroll over empty.
      let maxLimit = currentModifiableTraitType.traits.endIndex - 1
      let minLimit = 0
      
      switch currentModifiableTraitType {
      case .background:
        break
        
      case .body:
        seed.body = max(
          min(seed.body + index, maxLimit),
          minLimit)
        
      case .accessory:
        seed.accessory = max(
          min(seed.accessory + index, maxLimit),
          minLimit)
        
      case .head:
        seed.head = max(
          min(seed.head + index, maxLimit),
          minLimit)
        
      case .glasses:
        seed.glasses = max(
          min(seed.glasses + index, maxLimit),
          minLimit)
      }
    }
    
    /// Returns a boolean indicating if an index is the selected index given a trait type
    func isSelected(_ index: Int, traitType: TraitType) -> Bool {
      switch traitType {
      case .background:
        return index == seed.background
      case .body:
        return index == seed.body
      case .accessory:
        return index == seed.accessory
      case .head:
        return index == seed.head
      case .glasses:
        return index == seed.glasses
      }
    }
    
    /// Moves the currently selected `Noun's Trait` by the given offset.
    func traitOffset(for type: TraitType, by offsetX: Double = 0) -> Double {
      switch type {
      case .background:
        return 0
        
      case .body:
        return (Double(seed.body) * -imageWidth) + offsetX
        
      case .accessory:
        return (Double(seed.accessory) * -imageWidth) + offsetX
        
      case .head:
        return (Double(seed.head) * -imageWidth) + offsetX
        
      case .glasses:
        return (Double(seed.glasses) * -imageWidth) + offsetX
      }
    }
    
    /// Recognizes if the drag gesture should be enabled.
    /// - Parameter type: The Noun's `Trait Type` to validate.
    func isDraggingEnabled(for type: TraitType) -> Bool {
      currentModifiableTraitType == type
    }
  }
}
