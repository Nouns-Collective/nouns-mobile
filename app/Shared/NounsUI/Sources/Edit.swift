//
//  Edit.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-09.
//

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
