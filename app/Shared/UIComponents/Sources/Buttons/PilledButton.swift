//
//  PilledButton.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

/// The button style configuration for the StandardButton
public struct PilledButtonStyle<Label: View>: ButtonStyle {
    
    /// The appearance of the button (light/dark)
    let appearance: PilledButton<Label>.Appearance
    
    /// The height of the button
    let fill: Set<PilledButton<Label>.Fill>
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: fill.contains(.width) ? .infinity : nil, maxHeight: fill.contains(.height) ? .infinity : nil)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .foregroundColor(appearance == .dark ? Color.white : Color.black)
            .background(appearance == .dark ? Color.black.opacity(0.85) : Color.white.opacity(0.85))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(), value: 3)
    }
}

///
public struct StandardButtonLabel: View {
    
    /// The icon for the button
    let image: Image?
    
    /// The text for the button, appearing on the right side of the icon
    let text: String?
    
    private var iconOnly: Bool {
        return image != nil && text == nil
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            if let image = image {
                image
                    .font(Font.body.weight(.medium))
            }
            
            if let text = text {
                Text(text)
                    .font(Font.body.weight(.medium))
            }
        }.padding(.horizontal, iconOnly ? 0 : 6)
    }
}

///
public struct PilledButton<Label: View>: View {
    
    /// Enumeration declaration for the style for the button appearance (light/dark)
    public enum Appearance {
        case dark, light
    }
    
    /// Enumeration declaration for the fill mode of the button
    public enum Fill {
        case height, width
    }
    
    /// The user-set label content for the button
    private let label: Label
    
    /// The action for the button once tapped
    private let action: () -> ()
    
    /// The appearance of the button (light/dark)
    private let appearance: Appearance
    
    /// The fill mode for the buttons height and width
    private let fill: Set<Fill>
    
    /// Initializes a standard button with a custom view for the label and a designated action for when the button is tapped
    ///
    /// Using a custom label view.
    ///
    /// ```swift
    /// PilledButton {
    ///     HStack {
    ///         Image(systemName: "arrow.clockwise")
    ///             .font(Font.body.weight(.medium))
    ///
    ///         Text("Black Button")
    ///             .font(Font.body.weight(.medium))
    ///     }.padding(.horizontal, 6)
    /// } action: {
    ///     print("Tapped")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - label: A view for the label of the button
    ///   - action: The action function for when the button is tapped
    ///   - appearance: The appearance of the button (dark/light)
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        @ViewBuilder label: () -> Label,
        action: @escaping () -> (),
        appearance: Appearance = .dark,
        fill: Set<Fill> = []
    ) {
        self.label = label()
        self.action = action
        self.appearance = appearance
        self.fill = fill
    }
    
    /// Initializes a standard button with an optional system icon and optional text to create a standard button, as well as a designated action
    ///
    /// Using a standard button label.
    ///
    /// ```swift
    /// PilledButton(systemImage: "xmark",
    ///              text: "Cancel",
    ///              action: {},
    ///              appearance: .dark)
    /// ```
    ///
    /// Using a standard button label, with only an icon.
    ///
    /// ```swift
    /// PilledButton(systemImage: "xmark",
    ///              action: {},
    ///              appearance: .light)
    ///
    /// ```
    ///
    /// - Parameters:
    ///   - systemImage: The name of a system image for the button's icon (optional)
    ///   - text: The text for the button (optional)
    ///   - action: The action function for when the button is tapped
    ///   - appearance: The appearance of the button (dark/light)
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        systemImage: String,
        text: String? = nil,
        action: @escaping () -> (),
        appearance: Appearance = .dark,
        fill: Set<Fill> = []
    ) where Label == StandardButtonLabel {
        self.label = {
            return StandardButtonLabel(image: Image(systemName: systemImage), text: text)
        }()
        
        self.action = action
        self.appearance = appearance
        self.fill = fill
    }
    
    /// Initializes a standard button with an optional system icon and optional text to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// PilledButton(text: "Cancel",
    ///              action: {},
    ///              appearance: .light)
    ///
    /// HStack {
    ///     PilledButton(text: "Cancel",
    ///                  action: {},
    ///                  appearance: .light,
    ///                  fill: [.width, .height])
    ///         .frame(maxHeight: .infinity)
    ///
    ///     PilledButton(text: "Save",
    ///                  action: {},
    ///                  appearance: .dark,
    ///                 fill: [.width, .height])
    ///         .frame(maxWidth: .infinity)
    ///
    ///  }.frame(height: 50)
    /// ```
    ///
    ///
    /// - Parameters:
    ///   - image: The image for the button's icon (optional)
    ///   - text: The text for the button (optional)
    ///   - action: The action function for when the button is tapped
    ///   - appearance: The appearance of the button (dark/light)
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        image: Image? = nil,
        text: String? = nil,
        action: @escaping () -> (),
        appearance: Appearance = .dark,
        fill: Set<Fill> = []
    ) where Label == StandardButtonLabel {
        self.label = {
            return StandardButtonLabel(image: image, text: text)
        }()
        
        self.action = action
        self.appearance = appearance
        self.fill = fill
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            label
                .padding(12)
        }
        .buttonStyle(PilledButtonStyle(appearance: appearance, fill: fill))
    }
}
