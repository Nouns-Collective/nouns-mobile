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
            .cornerRadius(6)
            .animation(.spring())
    }
}

/// A label for buttons with text and an optional icon on th left of the text as well as an optional accessory image
public struct StandardButtonLabel: View {
    
    /// The optional icon to show on the left of the text
    let icon: Image?
    
    /// The icon for the button on the far right of the button (accessory image)
    let accessoryImage: Image?
    
    /// The text for the button, appearing on the right side of the icon
    let text: String
    
    /// Boolean value to determine whether the button should be full width
    let fullWidth: Bool
    
    private var onlyText: Bool {
        icon == nil
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Label {
                Text(text)
                    .font(Font.custom(.medium, relativeTo: .callout))
            } icon: {
                icon
            }.labelStyle(.titleAndIcon(spacing: onlyText ? 0 : 10))
            
            if fullWidth {
                Spacer()
            }
            
            if let image = accessoryImage {
                image
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding(16)
    }
}

public struct IconButtonLabel: View {
    
    /// The optional icon to show on the left of the text
    let icon: Image

    public var body: some View {
        icon
            .aspectRatio(contentMode: .fit)
            .padding(8)
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
    
    /// Initializes a standard button with a custom view for the label and a designated action for when the button is tapped
    ///
    /// Using a custom label view.
    ///
    /// ```swift
    /// SoftButton {
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
    
    /// Initializes a soft button with an optional  icon, text, and optional accessory image to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// OutlineButton(icon: {
    ///   Image(systemName: "hand.thumbsup.fill")
    /// }, text: "Get Started", accessoryImage: {
    ///     Image(systemName: "arrow.right")
    /// }, action: {}, fill: [.width])
    /// ```
    ///
    /// - Parameters:
    ///   - icon: The image for the button's icon (optional)
    ///   - text: The text for the button (optional)
    ///   - accessoryImage: The accessory image of the button
    ///   - action: The action function for when the button is tapped
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        @ViewBuilder icon: () -> Image? = { nil },
        text: String,
        @ViewBuilder accessoryImage: () -> Image? = { nil },
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == StandardButtonLabel {
        self.label = {
            return StandardButtonLabel(icon: icon(), accessoryImage: accessoryImage(), text: text, fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
    }
    
    /// Initializes a soft button with only an icon as it's label, as well as a designated action
    ///
    /// Using an standard button label, with only text
    ///
    /// ```swift
    /// Soft Button(icon: {
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
            return IconButtonLabel(icon: icon())
        }()
        
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            label
        }
        .buttonStyle(SoftButtonStyle(fill: fill))
    }
}

// TODO: Remove the preview and put the example in the documentation.
struct Previews: PreviewProvider {    
    struct PreviewView: View {
        init() {
            UIComponents.configure()
        }
        
        var body: some View {
            VStack {
                VStack {
                    SoftButton(text: "Get Started", accessoryImage: {
                        Image(systemName: "arrow.right")
                    }, action: {}, fill: [.width])
                    
                    SoftButton(icon: {
                        Image(systemName: "hand.thumbsup.fill")
                    }, text: "Get Started", accessoryImage: {
                        Image(systemName: "arrow.right")
                    }, action: {}, fill: [.width])

                    HStack {
                        SoftButton(text: "Get Started", accessoryImage: {
                            Image(systemName: "hand.thumbsup.fill")
                        }, action: {}, fill: [.width])
                        SoftButton(text: "Get Started", accessoryImage: {
                            Image(systemName: "hand.thumbsdown")
                        }, action: {}, fill: [.width])
                    }
                }.padding()
                    .background(Color.componentSeriousMango)
                
                VStack {
                    SoftButton(text: "Get Started", accessoryImage: {
                        Image(systemName: "arrow.right")
                    }, action: {}, fill: [.width])
                    
                    HStack {
                        SoftButton(text: "Get Started", accessoryImage: {
                            Image(systemName: "hand.thumbsup.fill")
                        }, action: {}, fill: [.width])
                        SoftButton(text: "Get Started", accessoryImage: {
                            Image(systemName: "hand.thumbsdown")
                        }, action: {}, fill: [.width])
                    }
                    
                    HStack {
                        SoftButton(icon: {
                            Image(systemName: "hand.thumbsup.fill")
                        }, action: {})
                        SoftButton(text: "Get Started", accessoryImage: {
                            Image(systemName: "hand.thumbsdown")
                        }, action: {}, fill: [.width])
                    }
                }.padding()
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
