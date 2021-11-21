//
//  SoftButton.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

/// The button style configuration for the SoftButton
public struct SoftButtonStyle<Label: View>: ButtonStyle {
    
    /// The height of the button
    public let fill: Set<SoftButton<Label>.Fill>
    
    /// Corner radius style of the button
    public let continuous: Bool
    
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
            .background(Color.black.opacity(configuration.isPressed ? 0.1 : 0.05))
            .clipShape(RoundedRectangle(cornerRadius: continuous ? 10 : 6, style: continuous ? .continuous : .circular))
            .animation(.spring())
    }
}

/// A label for buttons with text and an optional icon on the left of the text as well as an optional accessory image
public struct AccessoryButtonLabel<Accessory>: View where Accessory: View {
    
    /// The optional icon to show on the left of the text
    let icon: Image?
    
    /// The icon for the button on the far right of the button (accessory image)
    let accessoryImage: Image?
    
    let accessory: Accessory
    
    /// The text for the button, appearing on the right side of the icon
    let text: String
    
    /// Boolean value to determine whether the button should be full width
    let fullWidth: Bool
    
    private var onlyText: Bool {
        icon == nil
    }
    
    public init(
        _ text: String,
        icon: Image?,
        accessoryImage: Image?,
        fullWidth: Bool
    ) where Accessory == EmptyView {
        self.text = text
        self.icon = icon
        self.accessoryImage = accessoryImage
        self.accessory = EmptyView()
        self.fullWidth = fullWidth
    }
    
    public init(
        _ text: String,
        icon: Image?,
        accessory: Accessory,
        accessoryImage: Image? = nil,
        fullWidth: Bool
    ) {
        self.text = text
        self.icon = icon
        self.accessory = accessory
        self.accessoryImage = accessoryImage
        self.fullWidth = fullWidth
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Label {
                Text(text)
                    .font(Font.custom(.medium, size: 17))
            } icon: {
                icon?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            .labelStyle(.titleAndIcon(spacing: onlyText ? 0 : 12))
            
            if fullWidth {
                Spacer()
            }
            
            accessory
            
            if let accessory = accessoryImage {
                accessory
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16, alignment: .center)
            }
        }
        .padding(16)
    }
}

/// A label for buttons with text as well as an optional large accessory image
public struct LargeAccessoryButtonLabel: View {
    
    /// The icon for the button on the far right of the button (accessory image)
    let accessoryImage: Image?
    
    /// The text for the button, appearing on the right side of the icon
    let text: String
    
    /// Boolean value to determine whether the button should be full width
    let fullWidth: Bool
    
    public var body: some View {
        HStack(spacing: 10) {
            Text(text)
                .font(Font.custom(.medium, relativeTo: .callout))
            
            if fullWidth {
                Spacer()
            }
            
            if let accessory = accessoryImage {
                accessory
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 28, alignment: .center)
            }
        }
        .padding(16)
    }
}

public struct IconButtonLabel: View {
    
    /// The optional icon to show on the left of the text
    let icon: Image
    
    let padding: CGFloat

    public var body: some View {
        icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16, alignment: .center)
            .padding(padding)
    }
}

///
public struct SoftButton<Label: View>: View {
    
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
    
    /// The corner radius style of the button
    private var continuous: Bool = false
    
    /// A computer property to determine if the button's corner curve should be continuous or circular
    private var isContinuous: Bool {
        Label.self == IconButtonLabel.self || continuous
    }
    
    /// Initializes a standard button with a custom view for the label and a designated action for when the button is tapped
    ///
    /// Using a custom label view.
    ///
    /// ```swift
    /// SoftButton(label: {
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
    ///   - continuous: The corner radius style of the button. If true, the button will have a greater
    ///   corner radius and a continuous corner curve
    ///   - label: A view for the label of the button
    ///   - action: The action function for when the button is tapped
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        continuous: Bool = false,
        @ViewBuilder label: () -> Label,
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) {
        self.continuous = continuous
        self.label = label()
        self.action = action
        self.fill = fill
    }
    
    /// Initializes a soft button with an optional  icon, text, and optional accessory image to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// SoftButton(icon: {
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
    
    /// Initializes a soft button with text, and an optional large accessory image to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// SoftButton(text: "Get Started", largeAccessory: {
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
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == LargeAccessoryButtonLabel {
        self.label = {
            return LargeAccessoryButtonLabel(
                accessoryImage: largeAccessory(),
                text: text,
                fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
    }
    
    /// Initializes a soft button with only an icon as it's label, as well as a designated action
    ///
    /// Using an icon button label, with only an icon
    ///
    /// ```swift
    /// SoftButton(icon: {
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
            return IconButtonLabel(icon: icon(), padding: 8)
        }()
        
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            label
        }
        .buttonStyle(SoftButtonStyle(fill: fill, continuous: continuous))
    }
}
