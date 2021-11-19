//
//  InfoCell.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-15.
//

import SwiftUI

public struct InfoCell<Icon: View, CalloutIcon: View, Accessory: View>: View {
    
    /// The icon on the left of the information cell
    private let icon: Icon
    
    /// The main text for the information cell
    private let text: String
    
    /// An optional callout icon view
    private let calloutIcon: CalloutIcon?
    
    /// An optional callout text property, which displays text after the main text in a bold font
    private let calloutText: String?
    
    /// An optional accessory icon view
    private let accessory: Accessory?
    
    /// An tap action for when the information cell is tapped
    private let tapAction: (() -> Void)?
    
    /// Initializes an information cell with a left icon, some text, a callout string and icon, an accessory view, and optional tap action
    ///
    /// ```swift
    /// InfoCell(text: "Held by", calloutText: "beautifulpunks.eth", icon: {
    ///     Image.holder
    ///         .resizable()
    ///         .aspectRatio(contentMode: .fit)
    ///         .frame(width: 35, height: 35, alignment: .center)
    /// }, accessory: {
    ///     Image.mdArrowRight
    ///         .resizable()
    ///         .aspectRatio(contentMode: .fit)
    ///         .frame(width: 20, height: 20, alignment: .center)
    /// })
    /// ```
    ///
    /// - Parameters:
    ///   - text: The main text for the information cell
    ///   - calloutText: An optional callout text property, which displays text after the main text in a bold font
    ///   - icon: The icon on the left of the information cell
    ///   - calloutIcon: An optional callout icon view
    ///   - accessory: An optional accessory icon view
    ///   - tapAction: An tap action for when the information cell is tapped
    public init(
        text: String,
        calloutText: String? = nil,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder calloutIcon: () -> CalloutIcon,
        @ViewBuilder accessory: () -> Accessory,
        tapAction: (() -> Void)? = nil
    ) {
        self.icon = icon()
        self.text = text
        self.calloutIcon = calloutIcon()
        self.calloutText = calloutText
        self.accessory = accessory()
        self.tapAction = tapAction
    }
    
    /// Initializes an information cell with a left icon, some text, a callout string and icon, and optional tap action
    ///
    /// ```swift
    /// InfoCell(text: "Held by", calloutText: "beautifulpunks.eth", icon: {
    ///    Image.holder
    ///     .resizable()
    ///     .aspectRatio(contentMode: .fit)
    ///     .frame(width: 35, height: 35, alignment: .center)
    ///  }, calloutIcon: {
    ///     Image.eth
    ///  )
    /// ```
    ///
    /// - Parameters:
    ///   - text: The main text for the information cell
    ///   - calloutText: An optional callout text property, which displays text after the main text in a bold font
    ///   - icon: The icon on the left of the information cell
    ///   - calloutIcon: An optional callout icon view
    ///   - tapAction: An tap action for when the information cell is tapped
    public init(
        text: String,
        calloutText: String? = nil,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder calloutIcon: () -> CalloutIcon,
        tapAction: (() -> Void)? = nil
    ) where Accessory == EmptyView {
        self.icon = icon()
        self.text = text
        self.calloutIcon = calloutIcon()
        self.calloutText = calloutText
        self.accessory = nil
        self.tapAction = tapAction
    }
    
    /// Initializes an information cell with a left icon, some text, a callout string, an accessory view, and optional tap action
    ///
    /// ```swift
    /// InfoCell(text: "Held by", calloutText: "beautifulpunks.eth", icon: {
    ///    Image.holder
    ///     .resizable()
    ///     .aspectRatio(contentMode: .fit)
    ///     .frame(width: 35, height: 35, alignment: .center)
    ///  }, accessory: {
    ///     Image.mdArrowRight
    ///     .resizable()
    ///     .aspectRatio(contentMode: .fit)
    ///     .frame(width: 20, height: 20, alignment: .center)
    /// })
    /// ```
    ///
    /// - Parameters:
    ///   - icon: The icon on the left of the information cell
    ///   - text: The main text for the information cell
    ///   - calloutText: An optional callout text property, which displays text after the main text in a bold font
    ///   - accessory: An optional accessory icon view
    ///   - tapAction: An tap action for when the information cell is tapped
    public init(
        text: String,
        calloutText: String? = nil,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder accessory: () -> Accessory,
        tapAction: (() -> Void)? = nil
    ) where CalloutIcon == EmptyView {
        self.icon = icon()
        self.text = text
        self.calloutIcon = nil
        self.calloutText = calloutText
        self.accessory = accessory()
        self.tapAction = tapAction
    }
    
    /// Initializes an information cell with a left icon, some text, a callout string, and optional tap action
    ///
    /// ```swift
    /// InfoCell(text: "Held by", calloutText: "beautifulpunks.eth", icon: {
    ///    Image.holder
    ///     .resizable()
    ///     .aspectRatio(contentMode: .fit)
    ///     .frame(width: 35, height: 35, alignment: .center)
    ///  })
    /// ```
    ///
    /// - Parameters:
    ///   - icon: The icon on the left of the information cell
    ///   - text: The main text for the information cell
    ///   - calloutText: An optional callout text property, which displays text after the main text in a bold font
    ///   - tapAction: An tap action for when the information cell is tapped
    public init(
        text: String,
        calloutText: String? = nil,
        @ViewBuilder icon: () -> Icon,
        tapAction: (() -> Void)? = nil
    ) where Accessory == EmptyView, CalloutIcon == EmptyView {
        self.icon = icon()
        self.text = text
        self.calloutIcon = nil
        self.calloutText = calloutText
        self.accessory = nil
        self.tapAction = tapAction
    }
    
    public var body: some View {
        Label {
            HStack(spacing: 0) {
                Text(text)
                    .font(.custom(.regular, relativeTo: .subheadline))
                
                if let calloutText = calloutText {
                    Label(title: {
                        Text(calloutText)
                            .font(.custom(.medium, relativeTo: .subheadline))
                    }, icon: {
                        calloutIcon
                    })
                    .labelStyle(.titleAndIcon(spacing: 2))
                    .padding(.leading, 4)
                }
                
                Spacer()
                
                accessory
            }
        } icon: {
            icon
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tapAction?()
        }
    }
}

