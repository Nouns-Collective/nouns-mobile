//
//  OutlineButton.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-09.
//

import SwiftUI

/// The button style configuration for the StandardButton
public struct OutlineButtonStyle<Label: View>: ButtonStyle {
    
    /// The height of the button
    public let fill: Set<OutlineButton<Label>.Fill>
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: fill.contains(.width) ? .infinity : nil, maxHeight: fill.contains(.height) ? .infinity : nil)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .foregroundColor(Color.black)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.2), lineWidth: 6)
                    .offset(x: 0, y: 2)
                    .opacity(configuration.isPressed ? 1 : 0)
            }
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.black.opacity(0.08))
                    .opacity(configuration.isPressed ? 1 : 0)
            }
            .cornerRadius(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 2)
            }
            .animation(.spring(), value: configuration.isPressed)
    }
}

public struct OutlineButton<Label>: View where Label: View {
    
    /// Enumeration declaration for the fill mode of the button
    public enum Fill {
        case height, width
    }
    
    /// The user-set label content for the button
    private let label: Label
    
    /// The action for the button once tapped
    private let action: () -> Void
    
    /// The fill mode for the buttons height and width
    private var fill = Set<Fill>()
    
    /// Initializes an outline button with a custom view for the label and a designated action for when the button is tapped
    ///
    /// Using a custom label view.
    ///
    /// ```swift
    /// OutlineButton(label: {
    ///     HStack {
    ///         Image(systemName: "arrow.clockwise")
    ///             .font(Font.body.weight(.medium))
    ///
    ///         Text("Black Button")
    ///             .font(Font.body.weight(.medium))
    ///     }.padding(.horizontal, 6)
    /// } action: {
    ///     print("Tapped")
    /// })
    /// ```
    ///
    /// - Parameters:
    ///   - label: A view for the label of the button
    ///   - action: The action function for when the button is tapped
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        @ViewBuilder label: () -> Label,
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) {
        self.label = label()
        self.action = action
        self.fill = fill
    }
    
    /// Initializes an outline button with an optional  icon, text, and optional accessory image to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// OutlineButton(icon: {
    ///   Image(systemName: "hand.thumbsup.fill")
    /// }, text: "Get Started", smallAccessory: {
    ///     Image(systemName: "arrow.right")
    /// }, action: {}, fill: [.width])
    /// ```
    ///
    /// - Parameters:
    ///   - icon: The image for the button's icon (optional)
    ///   - text: The text for the button (optional)
    ///   - smallAccessory: The accessory image of the button
    ///   - action: The action function for when the button is tapped
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        text: String,
        @ViewBuilder icon: () -> Image? = { nil },
        @ViewBuilder smallAccessory: () -> Image? = { nil },
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == AccessoryButtonLabel<EmptyView> {
        self.label = {
            return AccessoryButtonLabel(
                text,
                icon: icon(),
                accessoryImage: smallAccessory(),
                fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
    }
    
    public init<V>(
        text: String,
        @ViewBuilder icon: () -> Image? = { nil },
        @ViewBuilder accessory: () -> V,
        @ViewBuilder smallAccessory: () -> Image? = { nil },
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == AccessoryButtonLabel<V>, V: View {
        self.label = {
            return AccessoryButtonLabel(
                text,
                icon: icon(),
                accessory: accessory(),
                accessoryImage: smallAccessory(),
                fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
    }
    
    /// Initializes an outline button with text, and an optional large accessory image to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// OutlineButton(icon: {
    ///   Image(systemName: "hand.thumbsup.fill")
    /// }, text: "Get Started", smallAccessory: {
    ///     Image(systemName: "arrow.right")
    /// }, action: {}, fill: [.width])
    /// ```
    ///
    /// - Parameters:
    ///   - icon: The image for the button's icon (optional)
    ///   - text: The text for the button (optional)
    ///   - largeAccessory: The accessory image of the button
    ///   - action: The action function for when the button is tapped
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        text: String,
        @ViewBuilder largeAccessory: () -> Image? = { nil },
        color: Color = .black,
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == LargeAccessoryButtonLabel {
        self.label = {
            return LargeAccessoryButtonLabel(
                accessoryImage: largeAccessory(),
                text: text,
                color: color,
                fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
    }
    
    /// Initializes an outline button with only an icon as it's label, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// OutlineButton(icon: {
    ///     Image(systemName: "hand.thumbsup.fill")
    /// }, action: {})
    /// ```
    ///
    /// - Parameters:
    ///   - icon: The image for the button's icon
    ///   - action: The action function for when the button is tapped
    public init(
        @ViewBuilder icon: () -> Image,
        action: @escaping () -> Void
    ) where Label == IconButtonLabel {
        self.label = {
            return IconButtonLabel(icon: icon(), padding: 12)
        }()
        
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            label
        }
        .buttonStyle(OutlineButtonStyle(fill: fill))
    }
}
