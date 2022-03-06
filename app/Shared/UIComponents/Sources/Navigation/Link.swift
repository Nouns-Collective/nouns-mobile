//
//  Link.swift
//  
//
//  Created by Ziad Tamim on 07.01.22.
//

import SwiftUI

public struct Link<Content, Destination>: View where Content: View, Destination: View {
  @Binding var isActive: Bool
  let content: () -> Content
  let destination: () -> Destination
  
  public init(
    isActive: Binding<Bool>,
    content: @escaping () -> Content,
    destination: @escaping () -> Destination
  ) {
    self._isActive = isActive
    self.content = content
    self.destination = destination
  }
  
  public var body: some View {
    NavigationLink(
      isActive: $isActive,
      destination: destination,
      label: { content() })
  }
}
