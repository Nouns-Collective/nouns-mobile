//
//  SafeLabel.swift
//  
//
//  Created by Ziad Tamim on 15.11.21.
//

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
                .font(.custom(.bold, size: 13))
                .redactable(style: .skeleton)
        }
    }
    
}
