//
//  CustomNavigationTitle.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-20.
//

import SwiftUI

/// Set as internal in order to divert use to view modifiers
fileprivate struct CustomNavigationTitle<Accessory: View>: ViewModifier {
    
    /// The title of the navigation bar
    private let title: String
    
    /// The right hand accessory view of the navigation bar
    private let accessory: Accessory
    
    /// Initializes a custom navigation title with an accessory view
    init(
        _ title: String,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.accessory = accessory()
    }
    
    /// Initializes a custom navigation title with an empty accessory view
    init(
        _ title: String
    ) where Accessory == EmptyView {
        self.title = title
        self.accessory = EmptyView()
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.custom(.bold, size: 52))
                    .foregroundColor(Color.componentNounsBlack)
                
                Spacer()
                
                accessory
            }
            
            content
        }
        .navigationBarHidden(true) // Hides stock navigation bar
    }
}

public extension View {
    
    /// Initializes a custom navigation title with an accessory view
    func customNavigationTitle<Accessory: View>(_ title: String, @ViewBuilder accessory: () -> Accessory) -> some View {
        modifier(CustomNavigationTitle(title, accessory: accessory))
    }
    
    /// Initializes a custom navigation title with an empty accessory view
    func customNavigationTitle(_ title: String) -> some View {
        modifier(CustomNavigationTitle(title))
    }
}
