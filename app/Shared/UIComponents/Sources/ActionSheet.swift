//
//  ActionSheet.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-04.
//

import SwiftUI

public struct ActionSheetLargeTitleView: View {
    
    /// A string for the large title at the top of the action sheet
    let title: String
    
    /// A boolean value to determine whether the title should be a user-editable text field
    let isEditing: Bool
    
    /// The placeholder for the text field, if necessary
    let placeholder: String
    
    /// A leading view to present above the title
    let leadingItem: AnyView?
    
    /// A trailing view to present to the right of the title
    let trailingItem: AnyView?
    
    @Binding private var text: String
    
    public init(
        title: String,
        isEditing: Bool,
        placeholder: String,
        leadingItem: AnyView?,
        trailingItem: AnyView?,
        text: Binding<String>
    ) {
        self.title = title
        self.isEditing = isEditing
        self.placeholder = placeholder
        self.leadingItem = leadingItem
        self.trailingItem = trailingItem
        self._text = text
    }
    
    public var body: some View {
        VStack {
            HStack {
                if let leadingItem = leadingItem {
                    leadingItem
                }
                
                Spacer()
                
                if let trailingItem = trailingItem {
                    trailingItem
                }
            }
            
            HStack(alignment: .center) {
                Text(title)
                    .font(.custom(.bold, size: 36))
                    .fixedSize(horizontal: false, vertical: true)
                    .edit(isActive: isEditing, text: $text, placeholder: placeholder)
                
                Spacer()
            }
        }
    }
}

public struct ActionSheetSmallTitleView: View {
    
    /// A string for the large title at the top of the action sheet
    let title: String
    
    /// A trailing view to present to the right of the title
    let trailingItem: AnyView?
    
    public var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.custom(.bold, size: 36))
                .lineLimit(2)
            
            Spacer()
            
            if let trailingItem = trailingItem {
                trailingItem
            }
        }
    }
}

public struct ActionSheetTitleView: View {
    
    /// A string for the large title at the top of the action sheet
    private let title: String
    
    /// A boolean value to determine whether the title should be a user-editable text field
    private let isEditing: Bool
    
    /// The placeholder for the text field, if necessary
    private let placeholder: String
    
    /// A binding string value for the text field, if necessary
    @Binding private var text: String
    
    /// A leading view to present above the title
    private let leadingItem: AnyView?
    
    /// A trailing view to present to the right of the title
    private let trailingItem: AnyView?
    
    public init<L, T>(
        title: String,
        isEditing: Bool = false,
        text: Binding<String> = .constant(""),
        placeholder: String = "",
        @ViewBuilder leadingItem: @escaping () -> L,
        @ViewBuilder trailingItem: @escaping () -> T
    ) where L: View, T: View {
        self.title = title
        self.isEditing = isEditing
        self._text = text
        self.placeholder = placeholder
        self.leadingItem = AnyView(leadingItem())
        self.trailingItem = AnyView(trailingItem())
    }
    
    public init<L>(
        title: String,
        isEditing: Bool = false,
        text: Binding<String> = .constant(""),
        placeholder: String = "",
        @ViewBuilder leadingItem: @escaping () -> L
    ) where L: View {
        self.title = title
        self.isEditing = isEditing
        self._text = text
        self.placeholder = placeholder
        self.leadingItem = AnyView(leadingItem())
        self.trailingItem = nil
    }
    
    public init<T>(
        title: String,
        isEditing: Bool = false,
        text: Binding<String> = .constant(""),
        placeholder: String = "",
        @ViewBuilder trailingItem: @escaping () -> T?
    ) where T: View {
        self.title = title
        self.isEditing = isEditing
        self._text = text
        self.placeholder = placeholder
        self.trailingItem = AnyView(trailingItem())
        self.leadingItem = nil
    }
    
    public init(
        title: String,
        isEditing: Bool = false,
        text: Binding<String> = .constant(""),
        placeholder: String = ""
    ) {
        self.title = title
        self.isEditing = isEditing
        self._text = text
        self.placeholder = placeholder
        self.trailingItem = nil
        self.leadingItem = nil
    }
    
    public var body: some View {
        if leadingItem != nil || isEditing {
            ActionSheetLargeTitleView(
                title: title,
                isEditing: isEditing,
                placeholder: placeholder,
                leadingItem: leadingItem,
                trailingItem: trailingItem,
                text: $text
            )
        } else {
            ActionSheetSmallTitleView(
                title: title,
                trailingItem: trailingItem
            )
        }
    }
}

/// An equatable view to hold action sheet bar items as a preference value
public struct ActionSheetBarItem: View, Equatable {
    
    let id: String = UUID().uuidString
    
    let view: AnyView
    
    public var body: some View {
        view
    }
    
    public static func == (lhs: ActionSheetBarItem, rhs: ActionSheetBarItem) -> Bool {
        lhs.id == rhs.id
    }
}

/// A preference key for the leading item of the action sheet
public struct ActionSheetLeadingBarItemKey: PreferenceKey {
    public static var defaultValue: ActionSheetBarItem?
    
    public static func reduce(value: inout ActionSheetBarItem?, nextValue: () -> ActionSheetBarItem?) {
        value = nextValue()
    }
}

/// A preference key for the trailing item of the action sheet
public struct ActionSheetTrailingBarItemKey: PreferenceKey {
    public static var defaultValue: ActionSheetBarItem?
    
    public static func reduce(value: inout ActionSheetBarItem?, nextValue: () -> ActionSheetBarItem?) {
        value = nextValue()
    }
}

extension View {
    /// An extension to set the leading bar item of the action sheet to a view
    public func actionSheetLeadingBarItem<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        preference(key: ActionSheetLeadingBarItemKey.self,
                   value: ActionSheetBarItem(view: AnyView(content())))
    }
    
    /// An extension to set the leading bar item of the action sheet to a view
    public func actionSheetTrailingBarItem<Content: View>(@ViewBuilder view: @escaping () -> Content) -> some View {
        preference(key: ActionSheetTrailingBarItemKey.self,
                   value: ActionSheetBarItem(view: AnyView(view())))
    }
}

public struct ActionSheet<Content: View>: View {
    
    /// A string for the large title at the top of the action sheet
    private let title: String
    
    /// A boolean value to determine whether the title should be a user-editable text field
    private let isEditing: Bool
    
    /// The placeholder for the text field, if necessary
    private let placeholder: String
    
    /// The background color of the action sheet
    let background: Color?
    
    /// The border color of the action sheet
    let borderColor: Color?
    
    /// A binding string value for the text field, if necessary
    @Binding private var text: String

    /// The body view of the action sheet
    private let content: () -> Content
    
    /// A leading view to present above the title
    @State private var leadingView: AnyView?
    
    /// A trailing view to present to the right of the title
    @State private var trailingView: AnyView?

    public init(
        title: String,
        isEditing: Bool = false,
        placeholder: String = "",
        background: Color? = Color.white,
        borderColor: Color? = Color.black,
        text: Binding<String> = .constant(""),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.isEditing = isEditing
        self.placeholder = placeholder
        self._text = text
        self.content = content
        self.background = background
        self.borderColor = borderColor
    }
    
    public var body: some View {
        PlainCell(
            background: background,
            borderColor: borderColor
        ) {
            VStack(alignment: .leading) {
                ActionSheetTitleView(title: title, isEditing: isEditing, text: $text, placeholder: placeholder) {
                    leadingView
                } trailingItem: {
                    trailingView
                }
                .padding(.bottom, 8)
                
                content()
              
            }.padding()
        }
        .onPreferenceChange(ActionSheetLeadingBarItemKey.self) { newValue in
            leadingView = newValue?.view
        }
        .onPreferenceChange(ActionSheetTrailingBarItemKey.self) { newValue in
            trailingView = newValue?.view
        }
    }
}
