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

/// A standard label for user interface items, consisting
/// of an icon with a title in type-safe way.
public struct SafeLabel: View {
    private let icon: Image
    private let title: String
    
    public init(_ title: String, icon: Image) {
        self.icon = icon
        self.title = title
    }
    
    public var body: some View {
        HStack(spacing: 3) {
            icon
            Text(title)
                .font(.custom(.bold, relativeTo: .caption))
                .redactable(style: .skeleton)
        }
    }
    
}
