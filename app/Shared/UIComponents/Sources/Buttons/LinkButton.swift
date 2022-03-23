//
//  LinkRow.swift
//  Nouns
//
//  Created by Ziad Tamim on 09.12.21.
//

import SwiftUI

/// Link settings row that controls a navigation presentation.
public struct LinkButton<Destination>: View where Destination: View {
    @Binding public var isActive: Bool
    private let leading: String
    private let trailing: String?
    private let icon: Image
    private let destination: () -> Destination
    
    public init(
        isActive: Binding<Bool>,
        leading: String,
        trailing: String,
        icon: Image,
        destination: @escaping () -> Destination
    ) {
        self._isActive = isActive
        self.leading = leading
        self.trailing = trailing
        self.icon = icon
        self.destination = destination
    }
    
    public var body: some View {
        ZStack {
            NavigationLink(
                isActive: $isActive,
                destination: destination,
                label: { EmptyView() })
            
            OutlineButton(
                text: leading,
                icon: { icon },
                accessory: {
                    if let trailingText = trailing {
                        Text(trailingText)
                            .font(.custom(.regular, relativeTo: .subheadline))
                            .foregroundColor(Color.componentNounsBlack.opacity(0.5))
                    }
                },
                smallAccessory: { Image.squareArrowDown },
                action: {
                    isActive.toggle()
                })
                .controlSize(.large)
        }
    }
}

struct LinkButton_Previews: PreviewProvider {
    
    static var previews: some View {
        LinkButton(
            isActive: .constant(false),
            leading: "App Icon",
            trailing: "Default",
            icon: .nounLogo,
            destination: {
                EmptyView()
            })
    }
}
