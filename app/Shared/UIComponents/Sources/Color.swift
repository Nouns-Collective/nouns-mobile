//
//  Color.swift
//  
//
//  Created by Ziad Tamim on 01.11.21.
//

import SwiftUI

/// Various component colors.
extension Color {
    
    /// A context-dependent apple color suitable for use in UI elements.
    public static let componentApple = Color("apple", bundle: .module)
    
    /// A context-dependent blueberry color suitable for use in UI elements.
    public static let componentBlueberry = Color("blueberry", bundle: .module)
    
    /// A context-dependent coolGrey color suitable for use in UI elements.
    public static let componentCoolGrey = Color("cool.grey", bundle: .module)
    
    /// A context-dependent dragronfruit color suitable for use in UI elements.
    public static let componentDragronfruit = Color("dragronfruit", bundle: .module)
    
    /// A context-dependent grape color suitable for use in UI elements.
    public static let componentGrape = Color("grape", bundle: .module)
    
    /// A context-dependent greyDark color suitable for use in UI elements.
    public static let componentGreyDark = Color("grey.dark", bundle: .module)
    
    /// A context-dependent koolaid color suitable for use in UI elements.
    public static let componentKoolaid = Color("koolaid", bundle: .module)
    
    /// A context-dependent lemonDrop color suitable for use in UI elements.
    public static let componentLemonDrop = Color("lemon.drop", bundle: .module)
    
    /// A context-dependent peach color suitable for use in UI elements.
    public static let componentPeach = Color("peach", bundle: .module)
    
    /// A context-dependent puke color suitable for use in UI elements.
    public static let componentPuke = Color("puke", bundle: .module)
    
    /// A context-dependent raspberry color suitable for use in UI elements.
    public static let componentRaspberry = Color("raspberry", bundle: .module)
    
    /// A context-dependent softGrey color suitable for use in UI elements.
    public static let componentSoftGrey = Color("soft.grey", bundle: .module)
    
    /// A context-dependent spearmint color suitable for use in UI elements.
    public static let componentSpearmint = Color("spearmint", bundle: .module)
    
    /// A context-dependent warmGrey color suitable for use in UI elements.
    public static let componentWarmGrey = Color("warm.grey", bundle: .module)
    
    /// A context-dependent cyanDream color suitable for use in UI elements.
    public static let componentCyanDream = Color("cyan.dream", bundle: .module)
    
    /// A context-dependent softViolet color suitable for use in UI elements.
    public static let componentSoftViolet = Color("soft.violet", bundle: .module)
    
    /// A context-dependent pinkPop color suitable for use in UI elements.
    public static let componentPinkPop = Color("pink.pop", bundle: .module)
    
    /// A context-dependent paleYellow color suitable for use in UI elements.
    public static let componentPaleYellow = Color("pale.yellow", bundle: .module)
    
    /// A context-dependent aubergine color suitable for use in UI elements.
    public static let componentAubergine = Color("aubergine", bundle: .module)
    
    /// A context-dependent wineStain color suitable for use in UI elements.
    public static let componentWineStain = Color("wine.stain", bundle: .module)
    
    /// A context-dependent superCyan color suitable for use in UI elements.
    public static let componentSuperCyan = Color("super.cyan", bundle: .module)
    
    /// A context-dependent melon color suitable for use in UI elements.
    public static let componentMelon = Color("melon", bundle: .module)
    
    /// A context-dependent whiteWash color suitable for use in UI elements.
    public static let componentwhiteWash = Color("white.wash", bundle: .module)
    
    /// A context-dependent innerRind color suitable for use in UI elements.
    public static let componentInnerRind = Color("inner.rind", bundle: .module)
    
    /// A context-dependent outerRind color suitable for use in UI elements.
    public static let componentOuterRind = Color("outer.rind", bundle: .module)
    
    /// A context-dependent softPeach color suitable for use in UI elements.
    public static let componentSoftPeach = Color("soft.peach", bundle: .module)
    
    /// A context-dependent softGreen color suitable for use in UI elements.
    public static let componentSoftGreen = Color("soft.green", bundle: .module)
    
    /// A context-dependent paleGreen color suitable for use in UI elements.
    public static let componentPaleGreen = Color("pale.green", bundle: .module)
    
    /// A context-dependent nuclear color suitable for use in UI elements.
    public static let componentNuclear = Color("nuclear", bundle: .module)
}

extension ShapeStyle where Self == Color {
    
    /// A context-dependent apple color suitable for use in UI elements.
    public static var componentApple: Color {
        .componentApple
    }
    
    /// A context-dependent blueberry color suitable for use in UI elements.
    public static var componentBlueberry: Color {
        .componentBlueberry
    }
    
    /// A context-dependent coolGrey color suitable for use in UI elements.
    public static var componentCoolGrey: Color {
        .componentCoolGrey
    }
    
    /// A context-dependent dragronfruit color suitable for use in UI elements.
    public static var componentDragronfruit: Color {
        .componentDragronfruit
    }
    
    /// A context-dependent grape color suitable for use in UI elements.
    public static var componentGrape: Color {
        .componentGrape
    }
    
    /// A context-dependent greyDark color suitable for use in UI elements.
    public static var componentGreyDark: Color {
        .componentGreyDark
    }
    
    /// A context-dependent koolaid color suitable for use in UI elements.
    public static var componentKoolaid: Color {
        .componentKoolaid
    }
    
    /// A context-dependent lemonDrop color suitable for use in UI elements.
    public static var componentLemonDrop: Color {
        .componentLemonDrop
    }
    
    /// A context-dependent peach color suitable for use in UI elements.
    public static var componentPeach: Color {
        .componentPeach
    }
    
    /// A context-dependent puke color suitable for use in UI elements.
    public static var componentPuke: Color {
        .componentPuke
    }
    
    /// A context-dependent raspberry color suitable for use in UI elements.
    public static var componentRaspberry: Color {
        .componentRaspberry
    }
    
    /// A context-dependent softGrey color suitable for use in UI elements.
    public static var componentSoftGrey: Color {
        .componentSoftGrey
    }
    
    /// A context-dependent spearmint color suitable for use in UI elements.
    public static var componentSpearmint: Color {
        .componentSpearmint
    }
    
    /// A context-dependent warmGrey color suitable for use in UI elements.
    public static var componentWarmGrey: Color {
        .componentWarmGrey
    }
    
    /// A context-dependent cyanDream color suitable for use in UI elements.
    public static var componentCyanDream: Color {
        .componentCyanDream
    }
    
    /// A context-dependent softViolet color suitable for use in UI elements.
    public static var componentSoftViolet: Color {
        .componentSoftViolet
    }
    
    /// A context-dependent pinkPop color suitable for use in UI elements.
    public static var componentPinkPop: Color {
        .componentPinkPop
    }
    
    /// A context-dependent paleYellow color suitable for use in UI elements.
    public static var componentPaleYellow: Color {
        .componentPaleYellow
    }
    
    /// A context-dependent aubergine color suitable for use in UI elements.
    public static var componentAubergine: Color {
        .componentAubergine
    }
    
    /// A context-dependent wineStain color suitable for use in UI elements.
    public static var componentWineStain: Color {
        .componentWineStain
    }
    
    /// A context-dependent superCyan color suitable for use in UI elements.
    public static var componentSuperCyan: Color {
        .componentSuperCyan
    }
    
    /// A context-dependent melon color suitable for use in UI elements.
    public static var componentMelon: Color {
        .componentMelon
    }
    
    /// A context-dependent whiteWash color suitable for use in UI elements.
    public static var componentwhiteWash: Color {
        .componentwhiteWash
    }
    
    /// A context-dependent innerRind color suitable for use in UI elements.
    public static var componentInnerRind: Color {
        .componentInnerRind
    }
    
    /// A context-dependent outerRind color suitable for use in UI elements.
    public static var componentOuterRind: Color {
        .componentOuterRind
    }
    
    /// A context-dependent softPeach color suitable for use in UI elements.
    public static var componentSoftPeach: Color {
        .componentSoftPeach
    }
    
    /// A context-dependent softGreen color suitable for use in UI elements.
    public static var componentSoftGreen: Color {
        .componentSoftGreen
    }
    
    /// A context-dependent paleGreen color suitable for use in UI elements.
    public static var componentPaleGreen: Color {
        .componentPaleGreen
    }
    
    /// A context-dependent nuclear color suitable for use in UI elements.
    public static var componentNuclear: Color {
        .componentNuclear
    }
}
