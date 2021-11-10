//
//  Gradient.swift
//  
//
//  Created by Ziad Tamim on 03.11.21.
//

import SwiftUI

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
