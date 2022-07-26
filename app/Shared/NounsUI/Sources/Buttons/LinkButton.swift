// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
        trailing: String? = nil,
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
