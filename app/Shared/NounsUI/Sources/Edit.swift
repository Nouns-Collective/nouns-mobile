// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

/// A view modifier to make any view into a user-editable text field, accepting a binding value and placeholder value
public struct Edit: ViewModifier {
  
  let isActive: Bool
  
  let placeholder: String
  
  @Binding var text: String
  
  public func body(content: Content) -> some View {
    VStack(alignment: .leading) {
      if isActive {
        TextField(placeholder, text: $text)
          .font(.custom(.bold, relativeTo: .title2))
        
        Divider()
          .frame(height: 2)
          .background(.black)
        
      } else {
        content
      }
    }
  }
}

extension View {
  
  public func edit(isActive: Bool, text: Binding<String>, placeholder: String) -> some View {
    modifier(Edit(isActive: isActive, placeholder: placeholder, text: text))
  }
}
