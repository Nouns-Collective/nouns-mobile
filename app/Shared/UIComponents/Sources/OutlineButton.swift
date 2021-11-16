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
            .animation(.spring())
    }
}

public struct OutlineButton<Label: View>: View {
    
    /// Enumeration declaration for the fill mode of the button
    public enum Fill {
        case height, width
    }
    
    /// The user-set label content for the button
    private let label: Label
    
    /// The action for the button once tapped
    private let action: () -> Void
    
    /// The fill mode for the buttons height and width
    private let fill: Set<Fill>
    
    /// Initializes a standard button with a custom view for the label and a designated action for when the button is tapped
    ///
    /// Using a custom label view.
    ///
    /// ```swift
    /// OutlineButton {
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
    
    /// Initializes a standard button with an optional system icon and optional text to create a standard button, as well as a designated action
    ///
    /// Using a standard button label.
    ///
    /// ```swift
    /// OutlineButton(systemImage: "xmark",
    ///              text: "Cancel",
    ///              action: {})
    /// ```
    ///
    /// Using a standard button label, with only an icon.
    ///
    /// ```swift
    /// OutlineButton(systemImage: "xmark",
    ///              action: {})
    ///
    /// ```
    ///
    /// - Parameters:
    ///   - systemImage: The name of a system image for the button's icon (optional)
    ///   - text: The text for the button (optional)
    ///   - action: The action function for when the button is tapped
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        systemImage: String,
        text: String? = nil,
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == StandardButtonLabel {
        self.label = {
            return StandardButtonLabel(image: Image(systemName: systemImage), text: text, fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
    }
    
    /// Initializes a standard button with an optional system icon and optional text to create a standard button, as well as a designated action
    ///
    /// Using a standard button label, with only text
    ///
    /// ```swift
    /// OutlineButton(text: "Cancel",
    ///              action: {})
    ///
    /// HStack {
    ///     OutlineButton(text: "Cancel",
    ///                  action: {},
    ///                  fill: [.width])
    ///         .frame(maxHeight: .infinity)
    ///
    ///     OutlineButton(text: "Save",
    ///                  action: {},
    ///                 fill: [.width])
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
    ///   - fill: A value to set the fill mode for the button's height and width
    public init(
        image: Image? = nil,
        text: String? = nil,
        action: @escaping () -> Void,
        fill: Set<Fill> = []
    ) where Label == StandardButtonLabel {
        self.label = {
            return StandardButtonLabel(image: image, text: text, fullWidth: fill.contains(.width))
        }()
        
        self.action = action
        self.fill = fill
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

// TODO: Removes the preview and place it in the documentation
struct OutlineButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                OutlineButton(systemImage: "arrow.right", text: "Get Started", action: {}, fill: [.width])
                
                HStack {
                    OutlineButton(systemImage: "hand.thumbsup.fill", text: "Get Started", action: {}, fill: [.width])
                    OutlineButton(systemImage: "hand.thumbsdown", text: "Get Started", action: {}, fill: [.width])
                }
            }.padding()
                .background(Color.componentSeriousMango)
            
            VStack {
                OutlineButton(systemImage: "arrow.right", text: "Get Started", action: {}, fill: [.width])
                
                HStack {
                    OutlineButton(systemImage: "hand.thumbsup.fill", text: "Get Started", action: {}, fill: [.width])
                    OutlineButton(systemImage: "hand.thumbsdown", text: "Get Started", action: {}, fill: [.width])
                }
                
                HStack {
                    OutlineButton(systemImage: "hand.thumbsup.fill", action: {})
                    OutlineButton(systemImage: "hand.thumbsdown", text: "Get Started", action: {}, fill: [.width])
                }
            }.padding()
        }.onAppear {
            UIComponents.configure()
        }
    }
}
