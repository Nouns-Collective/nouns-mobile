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

public struct SoftNavigationLink<Destination>: View where Destination: View {
    @Binding var isActive: Bool
    let title: String
    let trailing: () -> Image
    let destination: () -> Destination
    
    public init(
        isActive: Binding<Bool>,
        title: String,
        trailing: @escaping () -> Image,
        destination: @escaping () -> Destination
    ) {
        self._isActive = isActive
        self.title = title
        self.trailing = trailing
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink(
            isActive: $isActive,
            destination: destination,
            label: { EmptyView() })
        
        SoftButton(
            text: title,
            smallAccessory: trailing,
            action: { isActive.toggle() })
            .controlSize(.large)
    }
}
