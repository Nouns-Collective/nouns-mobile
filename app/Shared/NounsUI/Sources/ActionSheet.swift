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
          .font(.custom(.bold, relativeTo: .title2))
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
        .font(.custom(.bold, relativeTo: .title2))
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
  
  let id: String
  
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
  public func actionSheetLeadingBarItem<Content: View>(id: String, @ViewBuilder content: @escaping () -> Content) -> some View {
    preference(key: ActionSheetLeadingBarItemKey.self,
               value: ActionSheetBarItem(id: id, view: AnyView(content())))
  }
  
  /// An extension to set the leading bar item of the action sheet to a view
  public func actionSheetTrailingBarItem<Content: View>(id: String, @ViewBuilder content: @escaping () -> Content) -> some View {
    preference(key: ActionSheetTrailingBarItemKey.self,
               value: ActionSheetBarItem(id: id, view: AnyView(content())))
  }
}

public struct ActionSheet<Content: View>: View {
  
  /// A optional icon displayed above the title.
  private let icon: Image?
  
  /// A string for the large title at the top of the action sheet
  private let title: String
  
  /// A boolean value to determine whether the title should be a user-editable text field
  private let isEditing: Bool
  
  /// The placeholder for the text field, if necessary
  private let placeholder: String
  
  /// The background color of the action sheet
  let background: Color?
  
  /// A binding string value for the text field, if necessary
  @Binding private var text: String
  
  /// The body view of the action sheet
  private let content: () -> Content
  
  /// A leading view to present above the title
  @State private var leadingView: AnyView?
  
  /// A trailing view to present to the right of the title
  @State private var trailingView: AnyView?
  
  public init(
    icon: Image? = nil,
    title: String = "",
    isEditing: Bool = false,
    placeholder: String = "",
    background: Color? = Color.white,
    text: Binding<String> = .constant(""),
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.icon = icon
    self.title = title
    self.isEditing = isEditing
    self.placeholder = placeholder
    self._text = text
    self.content = content
    self.background = background
  }
  
  public var body: some View {
    PlainCell(
      background: background,
      borderColor: Color.clear
    ) {
      VStack(alignment: .leading) {
        icon
        
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
