//
//  Gradient.swift
//  
//
//  Created by Ziad Tamim on 03.11.21.
//

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
    public static let coolGreydient = GradientView(.coolGreydient, startPoint: .center, endPoint: .bottom)
    
    /// A context-dependent warmGreydient gradient suitable for use in UI elements.
    public static let warmGreydient = GradientView(.warmGreydient, startPoint: .center, endPoint: .bottom)
    
    /// A context-dependent cherrySunset gradient suitable for use in UI elements.
    public static let cherrySunset = GradientView(.cherrySunset)
    
    /// A context-dependent orangesicle gradient suitable for use in UI elements.
    public static let orangesicle = GradientView(.orangesicle)
    
    /// A context-dependent mangoChunks gradient suitable for use in UI elements.
    public static let mangoChunks = GradientView(.mangoChunks)
    
    /// A context-dependent lemonDrop gradient suitable for use in UI elements.
    public static let lemonDrop = GradientView(.lemonDrop)
    
    /// A context-dependent keyLimePie gradient suitable for use in UI elements.
    public static let keyLimePie = GradientView(.keyLimePie)
    
    /// A context-dependent kiwiDream gradient suitable for use in UI elements.
    public static let kiwiDream = GradientView(.kiwiDream)
    
    /// A context-dependent freshMint gradient suitable for use in UI elements.
    public static let freshMint = GradientView(.freshMint)
    
    /// A context-dependent oceanBreeze gradient suitable for use in UI elements.
    public static let oceanBreeze = GradientView(.oceanBreeze)
    
    /// A context-dependent blueberryJam gradient suitable for use in UI elements.
    public static let blueberryJam = GradientView(.blueberryJam)
    
    /// A context-dependent grapeAttack gradient suitable for use in UI elements.
    public static let grapeAttack = GradientView(.grapeAttack)
    
    /// A context-dependent magnoliaGarden gradient suitable for use in UI elements.
    public static let magnoliaGarden = GradientView(.magnoliaGarden)
    
    /// A context-dependent bubbleGum gradient suitable for use in UI elements.
    public static let bubbleGum = GradientView(.bubbleGum)
}

/// A gradient view for use in UI elements
public struct GradientView: ShapeStyle, View {
    
    /// An enumeration for the intended direction of the gradient
    let colors: [Color]
    
    /// The intended start point of the gradient
    let startPoint: UnitPoint
    
    /// The intended end point of the gradient
    let endPoint: UnitPoint
    
    public init(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottom) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    public init(_ gradient: GradientColors, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottom) {
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
