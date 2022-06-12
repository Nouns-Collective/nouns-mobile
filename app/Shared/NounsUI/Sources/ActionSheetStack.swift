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

public struct ActionSheetStack<T: RawRepresentable & Hashable, Content: View>: View where T.RawValue == Int {
  
  /// An enumeration to describe the direction of the next expected transition in the stack
  /// Push - appending a view to the stack hierarchy
  /// Pop - removing the current view from the stack hierachy and going back to the most previous view
  private enum Direction {
    case push
    case pop
  }
  
  /// The stack contains all view tags starting from the root up until but not including the current tag. The current tag is defined in the currentSheet binding property
  @State private var stack: [T] = []
  
  /// The current sheet tag
  @Binding private var currentSheet: T
  
  /// An array of action sheet stack items, defined in the content body of ActionSheetStack using preference keys
  @State private var items: [ActionSheetStackItem<T>] = []
  
  private let content: () -> Content
  
  private var title: String? {
    currentItem?.title
  }
  
  private var currentItem: ActionSheetStackItem<T>? {
    items.first(where: { $0.tag == currentSheet })
  }
  
  public init(
    selection: Binding<T>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self._currentSheet = selection
    self.content = content
  }
  
  /// The direction of the next expected transition
  @State private var direction: Direction = .push
  
  private var transition: AnyTransition {
    AnyTransition.asymmetric(
      insertion: .move(edge: direction == .push ? .trailing : .leading),
      removal: .move(edge: direction == .push ? .leading : .trailing)
    )
  }
  
  public var body: some View {
    PlainCell {
      ForEach(items, id: \.self) { item in
        if item.tag == currentSheet {
          VStack {
            if let item = currentItem {
              if stack.count > 0, let prevTag = stack.last {
                ActionSheetStackTitleView(
                  item: item,
                  pop: {
                    // Sets the direction for the transition to pop
                    // before the currentSheet has changed so that the transition
                    // is updated before the view updates
                    direction = .pop
                    
                    withAnimation {
                      currentSheet = prevTag
                    }
                  })
              } else {
                ActionSheetRootTitleView(item: item)
              }
            }
            
            item.view
          }
          .transition(transition)
        }
      }
      .padding()
    }
    .animation(.spring(), value: currentSheet)
    .background {
      /// Content needs to be displayed in entirety in order to set and access preference key values
      content()
        .opacity(0)
    }
    .onChange(of: currentSheet, perform: { [currentSheet] newValue in
      
      // Check if we are going forward or backward
      if let prevLast = stack.last, newValue == prevLast {
        // Going back
        _ = stack.popLast()
      } else {
        // Going forward
        stack.append(currentSheet)
      }
      
      // Reverts direction to push after every transition
      // Within this view, we switch the direction to pop when the xmark button is pressed (defined in this view)
      // However, if we the originating view changes the selection, we cannot anticipate it's direction until after the new
      // value has been received, which is too late as by then the view will have updated (with the incorrect transition direction)
      direction = .push
    })
    .onPreferenceChange(ActionSheetStackItemsKey.self) { items in
      self.items = items
    }
  }
}

/// A convenience extension to set the ActionSheetStackItemsKey preference value
extension View {
  
  public func actionSheetStackItem<T: RawRepresentable & Hashable>(tag: T, title: String? = nil, isEditing: Bool = false, exit: (() -> Void)? = nil) -> some View where T.RawValue == Int {
    let item = ActionSheetStackItem(tag: tag, view: AnyView(self), title: title, isEditing: isEditing, exit: exit)
    return preference(key: ActionSheetStackItemsKey.self, value: [item])
  }
}

struct ActionSheetStackItem<T: RawRepresentable & Hashable>: Equatable, Hashable where T.RawValue == Int {
  
  static func == (lhs: ActionSheetStackItem, rhs: ActionSheetStackItem) -> Bool {
    lhs.tag == rhs.tag && lhs.title == rhs.title
  }
  
  /// The unique tag of the action sheet stack item
  let tag: T
  
  /// The content view of this action sheet stack item
  let view: AnyView
  
  /// The large title string for this action sheet stack item (optional)
  /// This appears above the view content / body
  let title: String?
  
  /// A boolean value to determine whether the title should be a user-editable text field
  let isEditing: Bool
  
  /// An optional exit method to specify what action should take place
  /// if the user taps on the close bar button
  let exit: (() -> Void)?
  
  init(tag: T, view: AnyView, title: String?, isEditing: Bool, exit: (() -> Void)?) {
    self.tag = tag
    self.view = view
    self.title = title
    self.isEditing = isEditing
    self.exit = exit
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(tag.rawValue)
  }
}

/// A preference key to hold an array of all the views/items in an ActionSheetStackView
struct ActionSheetStackItemsKey<T: RawRepresentable & Hashable>: PreferenceKey where T.RawValue == Int {
  
  static var defaultValue: [ActionSheetStackItem<T>] { [] }
  
  static func reduce(value: inout [ActionSheetStackItem<T>], nextValue: () -> [ActionSheetStackItem<T>]) {
    value += nextValue()
  }
}

/// A navigation view for the action sheet stack view to be presented if this is the root view of the stack
/// Since it is the root view, it will not have a leading back button and only optionally have an exit button
private struct ActionSheetRootTitleView<T: RawRepresentable & Hashable>: View where T.RawValue == Int {
  
  let item: ActionSheetStackItem<T>
  
  var body: some View {
    ActionSheetTitleView(title: item.title ?? "", isEditing: item.isEditing, trailingItem: {
      if let exit = item.exit {
        SoftButton(
          icon: { Image.xmark },
          action: {
            exit()
          })
      } else {
        EmptyView()
      }
    })
  }
}

/// A navigation view for the action sheet stack view to be presented if this is not the root view of the stack
/// Since it is not the root view, it will automatically include a back button to go to the previous view on the stack
private struct ActionSheetStackTitleView<T: RawRepresentable & Hashable>: View where T.RawValue == Int {
  
  let item: ActionSheetStackItem<T>
  
  let pop: () -> Void
  
  var body: some View {
    ActionSheetTitleView(title: item.title ?? "", isEditing: item.isEditing) {
      SoftButton(
        icon: { Image.back },
        action: {
          pop()
        })
    } trailingItem: {
      if let exit = item.exit {
        SoftButton(
          icon: { Image.xmark },
          action: {
            exit()
          })
      } else {
        EmptyView()
      }
    }
  }
}
