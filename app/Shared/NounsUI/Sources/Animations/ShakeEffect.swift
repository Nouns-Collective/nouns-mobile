// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import Combine

/// An animation modifier that can be added to any view to add a (repeating or non-repeating) shaking animation.
private struct ShakeEffect: AnimatableModifier {
  
  /// The number of times to shake the view
  var shakeNumber: CGFloat = 0
  
  let offset: CGFloat
  
  let axis: Axis.Set
  
  let centered: Bool
  
  var animatableData: CGFloat {
    get {
      shakeNumber
    } set {
      shakeNumber = newValue
    }
  }
  
  /// If the view is meant to be centered in the shake animation, then the view will move to the right
  /// and to the left and back to the center when finished. Otherwise, the view will only move to the left when
  /// shaking and then return to it's original position in it's super view.
  ///
  /// The phase offset is not required if the shake is centered, but is required to be added if the view is only meant to move to the left
  private var centeredPhaseOffset: CGFloat {
    centered ? 0 : ((1 / 2) * .pi)
  }
  
  /// If the view is meant to be centered in the shake animation, then the view will move to the right
  /// and to the left and back to the center when finished. Otherwise, the view will only move to the left when
  /// shaking and then return to it's original position in it's super view.
  ///
  /// The offset is not required if the shake is centered, but is required to be added if the view is only meant to move to the left
  private var centeredOffset: CGFloat {
    centered ? 0 : offset
  }
  
  private var xOffset: CGFloat {
    axis.contains(.horizontal) ? sin(shakeNumber * .pi * 2 + centeredPhaseOffset) * offset - centeredOffset: 0
  }
  
  private var yOffset: CGFloat {
    axis.contains(.vertical) ? -sin(shakeNumber * .pi * 2 + centeredPhaseOffset) * offset - centeredOffset : 0
  }
  
  func body(content: Content) -> some View {
    content
      .offset(
        x: xOffset,
        y: yOffset
      )
  }
}

/// A view modifier to add the shake animatable modifier to any view
struct Shake: ViewModifier {
    
  /// A boolean state to determine when the view is shaking and when it is still (paused)
  @State private var shake: Bool = false
  
  private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
  
  /// The number of times to shake between rest periods
  private let shakeCount: Int
  
  /// The amount of time spent shaking
  private let shakeDuration: Double
  
  /// The max amount to offset the view when shaking
  private let maxOffset: Double
  
  /// The time to pause between shakes
  private let rest: CGFloat
  
  /// The direction in which to shake (horizontal, vertical, or both)
  private let axis: Axis.Set
  
  /// Whether or not the view should be centered (shake left and right, up and down) or not (only shake towards the left, or top)
  private let centered: Bool
  
  private var shakeEffect: ShakeEffect {
    ShakeEffect(shakeNumber: shake ? CGFloat(shakeCount) : 0, offset: maxOffset, axis: axis, centered: centered)
  }
  
  init(shakeCount: Int, shakeDuration: Double, maxOffset: CGFloat, axis: Axis.Set, rest: CGFloat, centered: Bool) {
    self.shakeCount = shakeCount
    self.shakeDuration = shakeDuration
    self.maxOffset = maxOffset
    self.axis = axis
    self.rest = rest
    self.centered = centered
    self.timer = Timer.publish(every: rest, on: .main, in: .common).autoconnect()
  }

  func body(content: Content) -> some View {
    content
      .modifier(shakeEffect)
      .onReceive(timer, perform: { _ in
        withAnimation(.easeInOut(duration: shakeDuration)) {
          shake.toggle()
        }
      })
  }
}

extension View {
  
  /// Adds a repeating shake effect (left and right) to any view
  public func shakeRepeatedly(shakeCount: Int = 2, shakeDuration: Double = 1.0, offset: CGFloat = 5, axis: Axis.Set = .horizontal, rest: CGFloat = 3.0, centered: Bool = false) -> some View {
    modifier(Shake(shakeCount: shakeCount, shakeDuration: shakeDuration, maxOffset: offset, axis: axis, rest: rest, centered: centered))
  }
}

struct Nudge_Previews: PreviewProvider {
  
  static var previews: some View {
    Image.fingergunsRight
      .shakeRepeatedly(shakeCount: 1, offset: 5, rest: 1.5, centered: true)
  }
}
