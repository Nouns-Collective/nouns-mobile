//
//  CustomNavigationTitle.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-20.
//

import SwiftUI

// TODO: Should use PreferenceKey to avoid ViewModifiers conflicts.
/// Set as internal in order to divert use to view modifiers
private struct SoftNavigationTitle<LeftAccessory, RightAccessory>: ViewModifier where LeftAccessory: View, RightAccessory: View {
    
    /// The title of the navigation bar
    private let title: String?
    
    /// The right hand accessory view of the navigation bar
    private let leftAccessory: LeftAccessory
    
    /// The right hand accessory view of the navigation bar
    private let rightAccessory: RightAccessory
    
    /// Initializes a custom navigation title with a left and right accessory view.
    init(
        _ title: String,
        @ViewBuilder leftAccessory: () -> LeftAccessory,
        @ViewBuilder rightAccessory: () -> RightAccessory
    ) {
        self.title = title
        self.leftAccessory = leftAccessory()
        self.rightAccessory = rightAccessory()
    }
    
    /// Initializes a custom navigation with a left and right accessory view.
    init(
        _ title: String? = nil,
        @ViewBuilder leftAccessory: () -> LeftAccessory,
        @ViewBuilder rightAccessory: () -> RightAccessory
    ) {
        self.title = title
        self.leftAccessory = leftAccessory()
        self.rightAccessory = rightAccessory()
    }
    
    /// Initializes a custom navigation title with a left accessory view.
    init(
        _ title: String? = nil,
        @ViewBuilder leftAccessory: () -> LeftAccessory
    ) where RightAccessory == EmptyView {
        self.title = title
        self.leftAccessory = leftAccessory()
        self.rightAccessory = EmptyView()
    }
    
    /// Initializes a custom navigation title with a right accessory view.
    init(
        _ title: String? = nil,
        @ViewBuilder rightAccessory: () -> RightAccessory
    ) where LeftAccessory == EmptyView {
        self.title = title
        self.leftAccessory = EmptyView()
        self.rightAccessory = rightAccessory()
    }
    
    /// Initializes a custom navigation title with an empty accessory view
    init(
        _ title: String
    ) where LeftAccessory == EmptyView, RightAccessory == EmptyView {
        self.title = title
        self.leftAccessory = EmptyView()
        self.rightAccessory = EmptyView()
    }
    
    func body(content: Content) -> some View {
        // TODO: Too much responsibilities for the `SoftNavigationTitle` component. Should have multiple styles.
        VStack {
            if !(leftAccessory.self is EmptyView) && !(rightAccessory.self is EmptyView) {
                plain
            } else {
                large
            }
            
            content
              .navigationBarHidden(true)
              .navigationBarBackButtonHidden(true)
        }
    }
    
    private var large: some View {
        VStack(alignment: .leading) {
            leftAccessory
                .padding(.leading, 20)
            
            HStack(alignment: .center) {
                if let title = title {
                    Text(title)
                        .font(.custom(.bold, relativeTo: .largeTitle))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(Color.componentNounsBlack)
                }
                
                Spacer()
                
                rightAccessory
            }
            .padding(.horizontal, 20)
            .padding(.top, (leftAccessory is EmptyView) ? 60 : 20)
            .padding(.bottom, 20)
        }
    }
    
    private var plain: some View {
        VStack(alignment: .leading) {
            HStack {
                leftAccessory
                Spacer()
                rightAccessory
            }
            .padding(.top, 20)
            
            if let title = title {
                Text(title)
                    .font(.custom(.bold, relativeTo: .largeTitle))
                    .minimumScaleFactor(0.7)
                    .foregroundColor(Color.componentNounsBlack)
            }
        }
        .padding(.horizontal, 20)
    }
}

public extension View {
    
    /// Initializes a custom navigation title with a right accessory view.
    func softNavigationTitle<RightAccessory: View>(
        _ title: String? = nil,
        @ViewBuilder rightAccessory: () -> RightAccessory
    ) -> some View {
        modifier(SoftNavigationTitle(title, rightAccessory: rightAccessory))
    }
    
    /// Initializes a custom navigation title with a left accessory view.
    func softNavigationTitle<LeftAccessory: View>(
        _ title: String? = nil,
        @ViewBuilder leftAccessory: () -> LeftAccessory
    ) -> some View {
        modifier(SoftNavigationTitle(title, leftAccessory: leftAccessory))
    }
    
    /// Initializes a custom navigation title with a left and right accessory view.
    func softNavigationTitle<LeftAccessory, RightAccessory>(
        _ title: String,
        @ViewBuilder leftAccessory: () -> LeftAccessory,
        @ViewBuilder rightAccessory: () -> RightAccessory
    ) -> some View where LeftAccessory: View, RightAccessory: View {
        modifier(
            SoftNavigationTitle(
                title,
                leftAccessory: leftAccessory,
                rightAccessory: rightAccessory))
    }
    
    /// Initializes a custom navigation title with a left and right accessory view.
    func softNavigationItems<LeftAccessory, RightAccessory>(
        @ViewBuilder leftAccessory: () -> LeftAccessory,
        @ViewBuilder rightAccessory: () -> RightAccessory
    ) -> some View where LeftAccessory: View, RightAccessory: View {
        modifier(
            SoftNavigationTitle(
                leftAccessory: leftAccessory,
                rightAccessory: rightAccessory))
    }
    
    /// Initializes a custom navigation title with an empty accessory view.
    func softNavigationTitle(_ title: String) -> some View {
        modifier(SoftNavigationTitle(title))
    }
}
