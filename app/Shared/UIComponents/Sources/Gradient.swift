//
//  Gradient.swift
//  
//
//  Created by Ziad Tamim on 03.11.21.
//

import SwiftUI

/// Various component gradients.
extension Gradient {
    
    /// A context-dependent CoolGreydient gradient suitable for use in UI elements.
    public static let coolGreydient = CoolGreydient()
    
    /// A context-dependent warmGreydient gradient suitable for use in UI elements.
    public static let warmGreydient = WarmGreydient()
    
    /// A context-dependent cherrySunset gradient suitable for use in UI elements.
    public static let cherrySunset = CherrySunset()
    
    /// A context-dependent orangesicle gradient suitable for use in UI elements.
    public static let orangesicle = Orangesicle()
    
    /// A context-dependent mangoChunks gradient suitable for use in UI elements.
    public static let mangoChunks = MangoChunks()
    
    /// A context-dependent lemonDrop gradient suitable for use in UI elements.
    public static let lemonDrop = LemonDrop()
    
    /// A context-dependent keyLimePie gradient suitable for use in UI elements.
    public static let keyLimePie = KeyLimePie()
    
    /// A context-dependent kiwiDream gradient suitable for use in UI elements.
    public static let kiwiDream = KiwiDream()
    
    /// A context-dependent freshMint gradient suitable for use in UI elements.
    public static let freshMint = FreshMint()
    
    /// A context-dependent oceanBreeze gradient suitable for use in UI elements.
    public static let oceanBreeze = OceanBreeze()
    
    /// A context-dependent blueberryJam gradient suitable for use in UI elements.
    public static let blueberryJam = BlueberryJam()
    
    /// A context-dependent grapeAttack gradient suitable for use in UI elements.
    public static let grapeAttack = GrapeAttack()
    
    /// A context-dependent magnoliaGarden gradient suitable for use in UI elements.
    public static let magnoliaGarden = MagnoliaGarden()
    
    /// A context-dependent bubbleGum gradient suitable for use in UI elements.
    public static let bubbleGum = BubbleGum()
}

/// A context-dependent CoolGreydient color suitable for use in UI elements.
public struct CoolGreydient: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentCoolGrey, .componentCanadianSky],
            startPoint: .center,
            endPoint: .bottom)
    }
}

/// A context-dependent WarmGreydient color suitable for use in UI elements.
public struct WarmGreydient: ShapeStyle, View {
    
    public init() {}
    
    public var body: some View {
        LinearGradient(
            colors: [.componentWarmGrey, .componentOctoberSky],
            startPoint: .center,
            endPoint: .bottom)
    }
}

/// A context-dependent CherrySunset color suitable for use in UI elements.
public struct CherrySunset: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentPeachy, .componentSoftCherry],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent Orangesicle color suitable for use in UI elements.
public struct Orangesicle: ShapeStyle, View {
        
    public var body: some View {
        LinearGradient(
            colors: [.componentOrangeCream, .componentClementine],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent MangoChunks color suitable for use in UI elements.
public struct MangoChunks: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentSeriousMango, .componentOrangeCream],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent LemonDrop color suitable for use in UI elements.
public struct LemonDrop: ShapeStyle, View {
    
    public init() {}

    public var body: some View {
        LinearGradient(
            colors: [.componentUnripeLemon, .componentSeriousMango],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent KeyLimePie color suitable for use in UI elements.
public struct KeyLimePie: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentUnripeLemon, .componentInsideLime],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent KiwiDream color suitable for use in UI elements.
public struct KiwiDream: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentConcord, .componentNuclearMint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent FreshMint color suitable for use in UI elements.
public struct FreshMint: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentAqua, .componentSpearmint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent OceanBreeze color suitable for use in UI elements.
public struct OceanBreeze: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentLinen, .componentAqua],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent BlueberryJam color suitable for use in UI elements.
public struct BlueberryJam: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentPerriwinkle, .componentMountainSky],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent GrapeAttack color suitable for use in UI elements.
public struct GrapeAttack: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentPurpleCabbage, .componentBrambleberry],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent MagnoliaGarden color suitable for use in UI elements.
public struct MagnoliaGarden: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentSmoothie, .componentEggplant],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent BubbleGum color suitable for use in UI elements.
public struct BubbleGum: ShapeStyle, View {
    
    public var body: some View {
        LinearGradient(
            colors: [.componentPeachy, .componentRaspberry],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}
