//
//  StandardButton.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

struct StandardButton<Label: View>: View {
    
    /// The user-set label content for the button
    let label: Label
    
    /// The action for the button once tapped
    let action: () -> ()
    
    
    /// Initializes a standard button with a view for the label and a designated action for when the button is tapped
    ///
    ///
    /// - Parameters:
    ///   - label: A view for the label of the button
    ///   - action: The action function for when the button is tapped
    @inlinable public init(
        @ViewBuilder label: () -> Label,
        action: @escaping () -> ()
    ) {
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
           label
                .padding(15)
        }
        .buttonStyle(StandardButtonStyle())
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton {
            HStack {
                Image(systemName: "arrow.clockwise")
                    .font(Font.body.weight(.medium))
                
                Text("Tap Me")
                    .font(Font.body.weight(.medium))
            }
        } action: {
            print("Tapped")
        }
    }
}

internal struct StandardButtonStyle: ButtonStyle {
    
    /// The button style configuration for the StandardButton
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .padding(.horizontal, 6)
            .foregroundColor(.white)
            .offset(y: -1)
            .background(Color.black.opacity(0.85))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.spring(), value: 3)
    }
}
