//
//  Shake.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-16.
//

import SwiftUI

struct ShakeEffect: AnimatableModifier {
  
  /// The number of times to shake the view
  var shakeNumber: CGFloat = 0
  
  var animatableData: CGFloat {
    get {
      shakeNumber
    } set {
      shakeNumber = newValue
    }
  }
  
  func body(content: Content) -> some View {
    content
      .offset(x: sin(shakeNumber * .pi * 2 + ((1 / 2) * .pi)) * 5 - 5)
  }
}

struct Shake: ViewModifier {
    
  /// A boolean state to determine when the view is shaking and when it is still (paused)
  @State private var shake: Bool = false
  
  private let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

  func body(content: Content) -> some View {
    content
      .modifier(ShakeEffect(shakeNumber: shake ? 2 : 0))
      .onReceive(timer, perform: { _ in
        withAnimation(.easeInOut(duration: 1.0)) {
          shake.toggle()
        }
      })
  }
}

extension View {
  
  /// Adds a repeating shake effect (left and right) to any view
  public func shakeRepeatedly() -> some View {
    modifier(Shake())
  }
}

struct Nudge_Previews: PreviewProvider {
  
  static var previews: some View {
    Image.fingergunsRight
      .shakeRepeatedly()
  }
}
