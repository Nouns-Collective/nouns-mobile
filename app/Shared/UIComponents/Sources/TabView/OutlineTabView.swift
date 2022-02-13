//
//  OutlineTabView.swift
//
//
//  Created by Ziad Tamim on 19.11.21.
//

import SwiftUI

/// Accessing the current selected tab in the environment.
private struct OutlineTabItemSelection: EnvironmentKey {
  static var defaultValue: Int = 0
}

/// Accessing the ids of the tabs that have been viewed at least once, in the environment.
private struct OutlineTabItemSelectedHistory: EnvironmentKey {
  static var defaultValue = Set<Int>()
}

/// Accessing the height of the tab view
public struct OutlineTabViewHeightKey: EnvironmentKey {
  public static var defaultValue: CGFloat = 0
}

extension EnvironmentValues {
  
  public var outlineTabViewHeight: CGFloat {
    get { self[OutlineTabViewHeightKey.self] }
    set { self[OutlineTabViewHeightKey.self] = newValue }
  }
  
  fileprivate var outlineTabItemSelection: Int {
    get { self[OutlineTabItemSelection.self] }
    set { self[OutlineTabItemSelection.self] = newValue }
  }
  
  fileprivate var outlineTabItemSelectedHistory: Set<Int> {
    get { self[OutlineTabItemSelectedHistory.self] }
    set { self[OutlineTabItemSelectedHistory.self] = newValue }
  }
}

/// Access all the items set by the client through the view modifier.
private struct OutlineTabItems: PreferenceKey {
  static var defaultValue: [OutlineTabItem] = []
  
  static func reduce(value: inout [OutlineTabItem], nextValue: () -> [OutlineTabItem]) {
    value += nextValue()
  }
}

/// Accessing the newly selected tab triggered by child views.
private struct OutlineTabItemSelectionDidChange: PreferenceKey {
  static var defaultValue: Int = 0
  
  static func reduce(value: inout Int, nextValue: () -> Int) {
    value += nextValue()
  }
}

/// Accessing `TabBar` visibility state.
private struct HideOutlineTabBar: EnvironmentKey {
  static var defaultValue = false
}

extension EnvironmentValues {
  
  fileprivate var hideOutlineTabBar: Bool {
    get { self[HideOutlineTabBar.self] }
    set { self[HideOutlineTabBar.self] = newValue }
  }
}

// TODO: Set `Tag` to conform to `Hashable`
private struct OutlineTabItem: Hashable, Identifiable {
  let id = UUID()
  // TODO: Icons should be type safe and conform to `View`.
  let normalStateIcon: String
  let selectedStateIcon: String
  let tag: Int
}

private struct OutlineTabBar: View {
  @Environment(\.outlineTabItemSelection) private var selection
  @State private var selectedItemTag = 0
  private let items: [OutlineTabItem]
  
  init(
    _ items: [OutlineTabItem]
  ) {
    self.items = items
  }
  
  var body: some View {
    HStack {
      ForEach(items) { item in
        tabItem(item)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(.vertical, 20)
    .padding(0)
    .background(Color.white)
    .border(width: 2, edges: [.top, .bottom], color: .black)
    .clipShape(Rectangle())
  }
  
  private func tabItem(_ item: OutlineTabItem) -> some View {
    let isSelected = selectedItemTag == item.tag
    let icon = isSelected ? item.selectedStateIcon : item.normalStateIcon
    
    return Image(icon, bundle: .module)
      .background(Group {
        if isSelected {
          Color.clear
            .preference(
              key: OutlineTabItemSelectionDidChange.self,
              value: item.tag)
        }
      })
      .onTapGesture {
        selectedItemTag = item.tag
      }
      .onAppear {
        selectedItemTag = selection
      }
  }
}

/// Management to display the content of the active tab.
private struct OutlineTabContent: ViewModifier {
  @Environment(\.outlineTabItemSelection) private var selection
  @Environment(\.outlineTabItemSelectedHistory) private var shownItems
  private let tag: Int
  
  private var shouldBeHidden: Bool {
    selection != tag && !shownItems.contains(tag)
  }
  
  init(
    _ tag: Int
  ) {
    self.tag = tag
  }
  
  func body(content: Content) -> some View {
    content
      .hidden(shouldBeHidden)
      .opacity(selection == tag ? 1 : 0)
  }
}

extension View {
  
  /// Sets the tab bar item associated with this view.
  /// - Parameters:
  ///   - normal: Sets the icon for normal state.
  ///   - selected: Sets the icon for selected state.
  ///   - tag: Sets the unique tag value of this view.
  public func outlineTabItem(normal: String, selected: String, tag: Int) -> some View {
    modifier(OutlineTabContent(tag))
      .preference(
        key: OutlineTabItems.self,
        value: [OutlineTabItem(normalStateIcon: normal,
                               selectedStateIcon: selected,
                               tag: tag)])
  }
  
  public func hideOutlineTabBar(_ state: Bool) -> some View {
    environment(\.hideOutlineTabBar, state)
  }
}

/// A view that switches between multiple child views using interactive user interface elements.
///
/// To create a user interface with tabs, place views in a `OutlineTabView` and apply
/// the `OutlineTabViewItem(_:)` modifier to the contents of each tab. The following
/// creates a tab view with three tabs:
///
/// ```
/// OutlineTabView(selection: $selection) {
///     Gradient.cherrySunset
///         .outlineTabItem(normal: "explore-outline", selected: "explore-fill", tag: 0)
///
///    Gradient.bubbleGum
///         .outlineTabItem(normal: "create-outline", selected: "create-fill", tag: 1)
///
///     Gradient.lemonDrop
///        .outlineTabItem(normal: "play-outline", selected: "play-fill", tag: 2)
///
///     Gradient.orangesicle
///         .outlineTabItem(normal: "settings-outline", selected: "settings-fill", tag: 3)
/// }
/// ```
///
/// Tab views only support tab items of type ``Image``. Passing any other type of view results in a visible but
/// empty tab item.
public struct OutlineTabView<Content>: View where Content: View {
  @Environment(\.hideOutlineTabBar) private var hideOutlineTabBar
  @Binding private var selection: Int
  @State private var items: [OutlineTabItem] = []
  @State private var shownItems = Set<Int>()
  private let content: Content
  
  @State private var tabBarHeight: CGFloat = 0
  
  public init(
    selection: Binding<Int>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content()
    self._selection = selection
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      content
        .environment(\.outlineTabViewHeight, tabBarHeight)
    }
    .safeAreaInset(edge: .bottom, spacing: 40) {
      OutlineTabBar(items)
        .opacity(hideOutlineTabBar ? 0 : 1)
        .background(
          /// A clear background to capture the height of the tab bar and pass it to it's children.
          /// This is to allow children to set the necessary amount of padding to the bottom of the view.
          GeometryReader { proxy in
            Color.clear
              .onChange(of: proxy.size.height, perform: { newValue in
                tabBarHeight = newValue
              })
          }
        )
    }
    .environment(\.outlineTabItemSelection, selection)
    .environment(\.outlineTabItemSelectedHistory, shownItems)
    .onPreferenceChange(OutlineTabItems.self) { items in
      self.items = items
    }
    .onPreferenceChange(OutlineTabItemSelectionDidChange.self) { newSelectedTabItem in
      selection = newSelectedTabItem
      shownItems.insert(newSelectedTabItem)
    }
  }
}

struct OutlineTabView_preview: PreviewProvider {
  
  static var previews: some View {
    OutlineTabView(selection: .constant(0)) {
      Gradient.cherrySunset
        .outlineTabItem(normal: "explore-outline", selected: "explore-fill", tag: 0)
      
      Gradient.bubbleGum
        .outlineTabItem(normal: "create-outline", selected: "create-fill", tag: 1)
      
      Gradient.lemonDrop
        .outlineTabItem(normal: "play-outline", selected: "play-fill", tag: 2)
      
      Gradient.orangesicle
        .outlineTabItem(normal: "settings-outline", selected: "settings-fill", tag: 3)
    }
  }
}
