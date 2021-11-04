//
//  Gradient.swift
//  
//
//  Created by Ziad Tamim on 03.11.21.
//

import SwiftUI

/// A context-dependent Rainbow color suitable for use in UI elements.
public struct RainbowGradient: ShapeStyle, View {
    
    public var body: some View {
        GeometryReader { proxy in
            RadialGradient(
                colors: [
                    .componentCyanDream,
                    .componentSoftViolet,
                    .componentPinkPop,
                    .componentPaleYellow,
                ],
                center: .bottomLeading,
                startRadius: proxy.size.width*0.25,
                endRadius: proxy.size.width+proxy.size.width*0.25
            )
        }
    }
}

/// A context-dependent Popsicle color suitable for use in UI elements.
public struct PopsicleGradient: ShapeStyle, View {
    
    public var body: some View {
        GeometryReader { proxy in
            RadialGradient(
                colors: [
                    .componentAubergine,
                    .componentWineStain,
                    .componentSuperCyan,
                    
                ], center: .bottomLeading,
                startRadius: proxy.size.width*0.3,
                endRadius: proxy.size.width+proxy.size.width*0.25
          )
        }
    }
}

/// A context-dependent Watermelon color suitable for use in UI elements.
public struct WatermelonGradient: ShapeStyle, View {
    
    public var body: some View {
        GeometryReader { proxy in
            RadialGradient(
                colors: [
                    .componentMelon,
                    .componentwhiteWash,
                    .componentInnerRind,
                    .componentOuterRind,
                ],
                center: .bottomLeading,
                startRadius: proxy.size.width*0.15,
                endRadius: proxy.size.width+proxy.size.width*0.35
            )
        }
    }
    
}

/// A context-dependent Cantalope color suitable for use in UI elements.
public struct CantalopeGradient: ShapeStyle, View {
    
    public var body: some View {
        GeometryReader { proxy in
            RadialGradient(
                colors: [
                    .componentSoftPeach,
                    .componentSoftGreen,
                    .componentPaleGreen,
                    .componentNuclear,
                ],
                center: .bottomLeading,
                startRadius: proxy.size.width*0.15,
                endRadius: proxy.size.width+proxy.size.width*0.35
            )
        }
    }
}
