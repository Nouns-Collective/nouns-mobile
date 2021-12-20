//
//  SoftNavigationLink.swift
//  
//
//  Created by Ziad Tamim on 08.12.21.
//

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
