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
    
    public static func allGradients() -> [[Color]] {
        [
            Gradient.coolGreydient.colors,
            Gradient.warmGreydient.colors,
            Gradient.cherrySunset.colors,
            Gradient.orangesicle.colors,
            Gradient.mangoChunks.colors,
            Gradient.lemonDrop.colors,
            Gradient.keyLimePie.colors,
            Gradient.kiwiDream.colors,
            Gradient.freshMint.colors,
            Gradient.oceanBreeze.colors,
            Gradient.blueberryJam.colors,
            Gradient.grapeAttack.colors,
            Gradient.magnoliaGarden.colors,
            Gradient.bubbleGum.colors
        ]
    }
}

/// A context-dependent CoolGreydient color suitable for use in UI elements.
public struct CoolGreydient: ShapeStyle, View {
    
    let colors: [Color] = [.componentCoolGrey, .componentCanadianSky]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .center,
            endPoint: .bottom)
    }
}

/// A context-dependent WarmGreydient color suitable for use in UI elements.
public struct WarmGreydient: ShapeStyle, View {
    
    let colors: [Color] = [.componentWarmGrey, .componentOctoberSky]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .center,
            endPoint: .bottom)
    }
}

/// A context-dependent CherrySunset color suitable for use in UI elements.
public struct CherrySunset: ShapeStyle, View {
    
    let colors: [Color] = [.componentPeachy, .componentSoftCherry]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent Orangesicle color suitable for use in UI elements.
public struct Orangesicle: ShapeStyle, View {
    
    let colors: [Color] = [.componentOrangeCream, .componentClementine]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent MangoChunks color suitable for use in UI elements.
public struct MangoChunks: ShapeStyle, View {
    
    let colors: [Color] = [.componentSeriousMango, .componentOrangeCream]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent LemonDrop color suitable for use in UI elements.
public struct LemonDrop: ShapeStyle, View {
    
    let colors: [Color] = [.componentUnripeLemon, .componentSeriousMango]
    
    public init() {}
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent KeyLimePie color suitable for use in UI elements.
public struct KeyLimePie: ShapeStyle, View {
    
    let colors: [Color] = [.componentUnripeLemon, .componentInsideLime]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent KiwiDream color suitable for use in UI elements.
public struct KiwiDream: ShapeStyle, View {
    
    let colors: [Color] = [.componentConcord, .componentNuclearMint]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent FreshMint color suitable for use in UI elements.
public struct FreshMint: ShapeStyle, View {
    
    let colors: [Color] = [.componentAqua, .componentSpearmint]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent OceanBreeze color suitable for use in UI elements.
public struct OceanBreeze: ShapeStyle, View {
    
    let colors: [Color] = [.componentLinen, .componentAqua]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent BlueberryJam color suitable for use in UI elements.
public struct BlueberryJam: ShapeStyle, View {
    
    let colors: [Color] = [.componentPerriwinkle, .componentMountainSky]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent GrapeAttack color suitable for use in UI elements.
public struct GrapeAttack: ShapeStyle, View {
    
    let colors: [Color] = [.componentPurpleCabbage, .componentBrambleberry]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent MagnoliaGarden color suitable for use in UI elements.
public struct MagnoliaGarden: ShapeStyle, View {
    
    let colors: [Color] = [.componentSmoothie, .componentEggplant]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

/// A context-dependent BubbleGum color suitable for use in UI elements.
public struct BubbleGum: ShapeStyle, View {
    
    let colors: [Color] = [.componentPeachy, .componentRaspberry]
    
    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}
