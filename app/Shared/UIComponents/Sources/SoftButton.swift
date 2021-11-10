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
    
    /// Background color determined by appearance property
    private var backgroundColor: Color {
        switch appearance {
        case .dark:
            return Color.black.opacity(0.85)
        case .light:
            return Color.white.opacity(0.85)
        case .custom(let color):
            return color
        }
    }
    
    /// Foreground color determined by appearance property
    private var foregroundColor: Color {
        switch appearance {
        case .dark:
            return Color.white
        default:
            return Color.black
        }
    }
    
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

///
public struct StandardButtonLabel: View {
    
    /// The icon for the button
    let image: Image?
    
    /// The text for the button, appearing on the right side of the icon
    let text: String?
    
    /// Boolean value to determine whether the button should be full width
    let fullWidth: Bool
    
    private var iconOnly: Bool {
        return image != nil && text == nil
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            if let text = text {
                Text(text)
                    .font(Font.custom(.medium, relativeTo: .callout))
            }
            
            if fullWidth {
                Spacer()
            }
            
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25, alignment: .center)
                    .font(Font.body.weight(.medium))
            }
        }
        .padding(16)
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
    private let fill: Set<Fill>
    
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
    
    /// Initializes a standard button with an optional system icon and optional text to create a standard button, as well as a designated action
    ///
    /// Using a standard button label.
    ///
    /// ```swift
    /// SoftButton(systemImage: "xmark",
    ///              text: "Cancel",
    ///              action: {})
    /// ```
    ///
    /// Using a standard button label, with only an icon.
    ///
    /// ```swift
    /// SoftButton(systemImage: "xmark",
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
    /// SoftButton(text: "Cancel",
    ///              action: {})
    ///
    /// HStack {
    ///     SoftButton(text: "Cancel",
    ///                  action: {},
    ///                  fill: [.width, .height])
    ///         .frame(maxHeight: .infinity)
    ///
    ///     SoftButton(text: "Save",
    ///                  action: {},
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
        .buttonStyle(SoftButtonStyle(fill: fill))
    }
}

struct Previews: PreviewProvider {    
    static var previews: some View {
        VStack {
            VStack {
                SoftButton(systemImage: "arrow.right", text: "Get Started", action: {}, fill: [.width])
                
                HStack {
                    SoftButton(systemImage: "hand.thumbsup.fill", text: "Get Started", action: {}, fill: [.width])
                    SoftButton(systemImage: "hand.thumbsdown", text: "Get Started", action: {}, fill: [.width])
                }
            }.padding()
            .background(Color(.sRGB, red: 253/255, green: 226/255, blue: 129/255, opacity: 1.0))
            
            VStack {
                SoftButton(systemImage: "arrow.right", text: "Get Started", action: {}, fill: [.width])
                
                HStack {
                    SoftButton(systemImage: "hand.thumbsup.fill", text: "Get Started", action: {}, fill: [.width])
                    SoftButton(systemImage: "hand.thumbsdown", text: "Get Started", action: {}, fill: [.width])
                }
                
                HStack {
                    SoftButton(systemImage: "hand.thumbsup.fill", action: {})
                    SoftButton(systemImage: "hand.thumbsdown", text: "Get Started", action: {}, fill: [.width])
                }
            }.padding()
        }.onAppear {
            UIComponents.configure()
        }
    }
}
