//
//  PilledButton.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

/// The button style configuration for the StandardButton
internal struct PilledButtonStyle: ButtonStyle {
    
    /// The foreground color of the button (label)
    let foregroundColor: Color
    
    /// The background color of the button
    let backgroundColor: Color
    
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .padding(.horizontal, 6)
            .foregroundColor(foregroundColor)
            .offset(y: -1)
            .background(backgroundColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(), value: 3)
    }
}

struct PilledButton<Label: View>: View {
    
    /// The user-set label content for the button
    let label: Label
    
    /// The action for the button once tapped
    let action: () -> ()
    
    /// The foreground color of the button (label)
    let foregroundColor: Color
    
    /// The background color of the button
    let backgroundColor: Color
    
    
    /// Initializes a standard button with a view for the label and a designated action for when the button is tapped
    ///
    ///
    /// - Parameters:
    ///   - label: A view for the label of the button
    ///   - action: The action function for when the button is tapped
    ///   - foregroundColor: The foreground color of the label content, defaults to white
    ///   - backgroundColor: The background color of the button, defaults to a black at 85% opacity
    @inlinable public init(
        @ViewBuilder label: () -> Label,
        action: @escaping () -> (),
        foregroundColor: Color = Color.white,
        backgroundColor: Color = Color.black.opacity(0.85)
    ) {
        self.label = label()
        self.action = action
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Button {
            action()
        } label: {
           label
                .padding(15)
        }
        .buttonStyle(PilledButtonStyle(foregroundColor: foregroundColor,
                                       backgroundColor: backgroundColor))
    }
}

struct PilledButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PilledButton {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(Font.body.weight(.medium))
                    
                    Text("Tap Me")
                        .font(Font.body.weight(.medium))
                }
            } action: {
                print("Tapped")
            }
            
            PilledButton(label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(Font.body.weight(.medium))
                    
                    Text("Tap Me")
                        .font(Font.body.weight(.medium))
                }
            }, action: {
                print("Tapped")
            }, foregroundColor: Color.white, backgroundColor: Color.blue)
        }
    }
}
