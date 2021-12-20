//
//  ActionSheetStack.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-08.
//

import SwiftUI

struct ActionSheetStackItem: Equatable, Hashable {
  
  static func == (lhs: ActionSheetStackItem, rhs: ActionSheetStackItem) -> Bool {
    lhs.tag == rhs.tag
  }
  
  /// The unique tag of the action sheet stack item
  let tag: Int
  
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
  
  init(tag: Int, view: AnyView, title: String?, isEditing: Bool, exit: (() -> Void)?) {
    self.tag = tag
    self.view = view
    self.title = title
    self.isEditing = isEditing
    self.exit = exit
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(tag)
  }
}

/// A preference key to hold an array of all the views/items in an ActionSheetStackView
struct ActionSheetStackItemsKey: PreferenceKey {
  
  static var defaultValue: [ActionSheetStackItem] = []
  
  static func reduce(value: inout [ActionSheetStackItem], nextValue: () -> [ActionSheetStackItem]) {
    value += nextValue()
  }
}

public struct ActionSheetStack<Content: View>: View {
  
  /// An enumeration to describe the direction of the next expected transition in the stack
  /// Push - appending a view to the stack hierarchy
  /// Pop - removing the current view from the stack hierachy and going back to the most previous view
  private enum Direction {
    case push
    case pop
  }
  
  /// The stack contains all view tags starting from the root up until but not including the current tag. The current tag is defined in the currentSheet binding property
  @State private var stack: [Int] = []
  
  /// The current sheet tag
  @Binding private var currentSheet: Int
  
  /// An array of action sheet stack items, defined in the content body of ActionSheetStack using preference keys
  @State private var items: [ActionSheetStackItem] = []
  
  private let content: () -> Content
  
  private var title: String? {
    items.indices.contains(currentSheet) ? items[currentSheet].title : nil
  }
  
  public init(
    selection: Binding<Int>,
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
            if let title = title {
              // TODO: - Refactor & Clean Up
              // Only show a back button if the view hierachy stack is not empty
              if stack.count > 0, let prevTag = stack.last {
                ActionSheetTitleView(title: title, isEditing: item.isEditing) {
                  SoftButton(
                    icon: { Image.back },
                    action: {
                      // Sets the direction for the transition to pop
                      // before the currentSheet has changed so that the transition
                      // is updated before the view updates
                      direction = .pop
                      
                      withAnimation {
                        currentSheet = prevTag
                      }
                    })
                } trailingItem: {
                  if let exit = items[currentSheet].exit {
                    SoftButton(
                      icon: { Image.xmark },
                      action: {
                        exit()
                      })
                  } else {
                    EmptyView()
                  }
                }
              } else {
                ActionSheetTitleView(title: title, trailingItem: {
                  if let exit = items[currentSheet].exit {
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
            
            item.view
          }
          .transition(transition)
        }
      }
      .padding()
    }
    .animation(.spring())
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
  
  public func actionSheetStackItem(tag: Int, title: String? = nil, isEditing: Bool = false, exit: (() -> Void)? = nil) -> some View {
    let item = ActionSheetStackItem(tag: tag, view: AnyView(self), title: title, isEditing: isEditing, exit: exit)
    return preference(key: ActionSheetStackItemsKey.self, value: [item])
  }
}
