// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

public enum GradientColors: CaseIterable {
  
  case coolGreydient
  case warmGreydient
  case cherrySunset
  case orangesicle
  case mangoChunks
  case lemonDrop
  case keyLimePie
  case kiwiDream
  case freshMint
  case oceanBreeze
  case blueberryJam
  case grapeAttack
  case magnoliaGarden
  case bubbleGum
  case recordButtonStroke
  
  public var colors: [Color] {
    switch self {
    case .coolGreydient:
      return [.componentCoolGrey, .componentCanadianSky]
    case .warmGreydient:
      return [.componentWarmGrey, .componentOctoberSky]
    case .cherrySunset:
      return [.componentPeachy, .componentSoftCherry]
    case .orangesicle:
      return [.componentOrangeCream, .componentClementine]
    case .mangoChunks:
      return [.componentSeriousMango, .componentOrangeCream]
    case .lemonDrop:
      return [.componentUnripeLemon, .componentSeriousMango]
    case .keyLimePie:
      return [.componentUnripeLemon, .componentInsideLime]
    case .kiwiDream:
      return [.componentConcord, .componentNuclearMint]
    case .freshMint:
      return [.componentAqua, .componentSpearmint]
    case .oceanBreeze:
      return [.componentLinen, .componentAqua]
    case .blueberryJam:
      return [.componentPerriwinkle, .componentMountainSky]
    case .grapeAttack:
      return [.componentPurpleCabbage, .componentBrambleberry]
    case .magnoliaGarden:
      return [.componentSmoothie, .componentEggplant]
    case .bubbleGum:
      return [.componentPeachy, .componentRaspberry]
    case .recordButtonStroke:
      return [.componentTurquoise, .componentAngularPurple, .componentAngularPink, .componentAngularYellow, .componentTurquoise]
    }
  }
}

/// Various component gradients.
extension Gradient {
  
  /// A collection of all the gradient color combinations
  public static let allGradients: [[Color]] = GradientColors.allCases.map { $0.colors }
  
  /// A context-dependent CoolGreydient gradient suitable for use in UI elements.
  public static let coolGreydient = Gradient(.coolGreydient, startPoint: .center, endPoint: .bottom)
  
  /// A context-dependent warmGreydient gradient suitable for use in UI elements.
  public static let warmGreydient = Gradient(.warmGreydient, startPoint: .center, endPoint: .bottom)
  
  /// A context-dependent cherrySunset gradient suitable for use in UI elements.
  public static let cherrySunset = Gradient(.cherrySunset)
  
  /// A context-dependent orangesicle gradient suitable for use in UI elements.
  public static let orangesicle = Gradient(.orangesicle)
  
  /// A context-dependent mangoChunks gradient suitable for use in UI elements.
  public static let mangoChunks = Gradient(.mangoChunks)
  
  /// A context-dependent lemonDrop gradient suitable for use in UI elements.
  public static let lemonDrop = Gradient(.lemonDrop)
  
  /// A context-dependent keyLimePie gradient suitable for use in UI elements.
  public static let keyLimePie = Gradient(.keyLimePie)
  
  /// A context-dependent kiwiDream gradient suitable for use in UI elements.
  public static let kiwiDream = Gradient(.kiwiDream)
  
  /// A context-dependent freshMint gradient suitable for use in UI elements.
  public static let freshMint = Gradient(.freshMint)
  
  /// A context-dependent oceanBreeze gradient suitable for use in UI elements.
  public static let oceanBreeze = Gradient(.oceanBreeze)
  
  /// A context-dependent blueberryJam gradient suitable for use in UI elements.
  public static let blueberryJam = Gradient(.blueberryJam)
  
  /// A context-dependent grapeAttack gradient suitable for use in UI elements.
  public static let grapeAttack = Gradient(.grapeAttack)
  
  /// A context-dependent magnoliaGarden gradient suitable for use in UI elements.
  public static let magnoliaGarden = Gradient(.magnoliaGarden)
  
  /// A context-dependent bubbleGum gradient suitable for use in UI elements.
  public static let bubbleGum = Gradient(.bubbleGum)
}

/// A gradient view for use in UI elements
public struct Gradient: ShapeStyle, View {
  
  /// An enumeration for the intended direction of the gradient
  private let colors: [Color]
  
  /// The intended start point of the gradient
  private let startPoint: UnitPoint
  
  /// The intended end point of the gradient
  private let endPoint: UnitPoint
  
  public init(
    colors: [Color],
    startPoint: UnitPoint = .topLeading,
    endPoint: UnitPoint = .bottom
  ) {
    self.colors = colors
    self.startPoint = startPoint
    self.endPoint = endPoint
  }
  
  public init(
    _ gradient: GradientColors,
    startPoint: UnitPoint = .topLeading,
    endPoint: UnitPoint = .bottom
  ) {
    self.colors = gradient.colors
    self.startPoint = startPoint
    self.endPoint = endPoint
  }
  
  public var body: some View {
    LinearGradient(
      colors: colors,
      startPoint: startPoint,
      endPoint: endPoint)
  }
}
