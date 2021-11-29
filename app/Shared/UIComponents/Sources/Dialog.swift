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
    
    @Binding private var isEditing: Bool
    @Binding private var text: String
    private let placeholder: String
    
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
        self.placeholder = ""
        self._text = .constant("")
        self._isEditing = .constant(false)
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
        self.placeholder = ""
        self._text = .constant("")
        self._isEditing = .constant(false)
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
        self.placeholder = ""
        self._text = .constant("")
        self._isEditing = .constant(false)
    }
    
    public init(
        title: String,
        isEditing: Binding<Bool>,
        text: Binding<String>,
        placeholder: String,
        trailing: @escaping () -> T,
        @ViewBuilder content: @escaping () -> Content
    ) where L == EmptyView {
        self.title = title
        self.leading = EmptyView()
        self.trailing = trailing()
        self.content = content
        self._isEditing = isEditing
        self._text = text
        self.placeholder = placeholder
    }
    
    public init(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) where L == EmptyView, T == EmptyView {
        self.title = title
        self.leading = EmptyView()
        self.trailing = EmptyView()
        self.content = content
        self.placeholder = ""
        self._text = .constant("")
        self._isEditing = .constant(false)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            leading
            
            HStack(alignment: .top) {
                Text(title)
                    .font(.custom(.bold, size: 36))
                    .lineLimit(2)
                    .edit(isActive: isEditing, text: $text, placeholder: placeholder)
                
                if !isEditing {
                    Spacer()
                    trailing
                        .padding(.top, 5)
                }
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
        TextField(placeholder, text: $text)
            .font(.custom(.bold, size: 36))
    }
}
