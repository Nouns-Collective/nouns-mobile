//
//  DialogNavigation.swift
//  
//
//  Created by Ziad Tamim on 27.11.21.
//

import SwiftUI

public struct DialogNavigation<Content, L, T>: View where Content: View, L: View, T: View {
    private let title: String
    private let leading: L
    private let trailing: T
    private let content: () -> Content
    
    public init(
        title: String,
        leading: @escaping () -> L,
        trailing: @escaping () -> T,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.leading = leading()
        self.trailing = trailing()
        self.content = content
    }
    
    public init(
        title: String,
        leading: @escaping () -> L,
        @ViewBuilder content: @escaping () -> Content
    ) where T == EmptyView {
        self.title = title
        self.leading = leading()
        self.trailing = EmptyView()
        self.content = content
    }
    
    public init(
        title: String,
        trailing: @escaping () -> T,
        @ViewBuilder content: @escaping () -> Content
    ) where L == EmptyView {
        self.title = title
        self.leading = EmptyView()
        self.trailing = trailing()
        self.content = content
    }
    
    public init(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) where L == EmptyView, T == EmptyView {
        self.title = title
        self.leading = EmptyView()
        self.trailing = EmptyView()
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            leading
            
            HStack(alignment: .top) {
                Text(title)
                    .font(.custom(.bold, size: 36))
                Spacer()
                trailing
                    .padding(.top, 5)
            }
            
            content()
        }
        .padding(16)
        .padding(.bottom, 4)
    }
}

///
extension View {
    
    public func edit(isActive: Bool, text: Binding<String>, placeholder: String) -> some View {
        modifier(Edit(isActive: isActive, text: text, placeholder: placeholder))
    }
}

public struct Edit: ViewModifier {
    let isActive: Bool
    @Binding var text: String
    let placeholder: String
    
    public func body(content: Content) -> some View {
        VStack {
            isActive ? AnyView(input) : AnyView(content)
            
            Divider()
                .frame(height: 2)
                .background(.black)
        }
    }
    
    private var input: some View {
        TextField("", text: $text)
            .font(.custom(.bold, size: 36))
    }
}
