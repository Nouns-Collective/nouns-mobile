//
//  OutlineTabView.swift
//
//
//  Created by Ziad Tamim on 19.11.21.
//

import SwiftUI

/// Accessing the height of the tab view
public struct OutlineTabViewHeightKey: EnvironmentKey {
  public static var defaultValue: CGFloat = 0
}

extension EnvironmentValues {
  
  public var outlineTabViewHeight: CGFloat {
    get { self[OutlineTabViewHeightKey.self] }
    set { self[OutlineTabViewHeightKey.self] = newValue }
  }
}

/// Access all the items set by the client through the view modifier.
private struct OutlineTabItems: PreferenceKey {
  static var defaultValue: [OutlineTabItem<AnyHashable>] = []
  
  static func reduce(value: inout [OutlineTabItem<AnyHashable>], nextValue: () -> [OutlineTabItem<AnyHashable>]) {
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

public class OutlineTabBarVisibilityManager: ObservableObject {
  @Published internal var isHidden: Bool = false
  
  public init() {}
  
  public func show() {
    isHidden = false
  }
  
  public func hide() {
    isHidden = true
  }
}

/// Accessing `TabBar` visibility state.
private struct OutlineTabBarVisibility: EnvironmentKey {
  static var defaultValue: OutlineTabBarVisibilityManager = OutlineTabBarVisibilityManager()
}

extension EnvironmentValues {
  
  public var outlineTabBarVisibility: OutlineTabBarVisibilityManager {
    get { self[OutlineTabBarVisibility.self] }
    set { self[OutlineTabBarVisibility.self] = newValue }
  }
}

public struct OutlineTabItem<T: Hashable>: Hashable, Identifiable {
  public let id = UUID()
  // TODO: Icons should be type safe and conform to `View`.
  let normalStateIcon: Image
  let selectedStateIcon: Image
  let tag: T
  
  public init(
    normalStateIcon: Image,
    selectedStateIcon: Image,
    tag: T
  ) {
    self.normalStateIcon = normalStateIcon
    self.selectedStateIcon = selectedStateIcon
    self.tag = tag
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

public struct OutlineTabBar<T: Hashable>: View {
  @Binding private var selectedItemTag: T
  private let items: [OutlineTabItem<T>]
  
  @Environment(\.outlineTabBarVisibility) var tabBarVisibility: OutlineTabBarVisibilityManager
  
  public init(
    selection: Binding<T>,
    _ items: [OutlineTabItem<T>]
  ) {
    self._selectedItemTag = selection
    self.items = items
  }
  
  public var body: some View {
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
    .offset(x: 0, y: tabBarVisibility.isHidden ? 120 : 0)
    .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3), value: tabBarVisibility.isHidden)
  }
  
  private func tabItem(_ item: OutlineTabItem<T>) -> some View {
    let isSelected = selectedItemTag == item.tag
    let icon = isSelected ? item.selectedStateIcon : item.normalStateIcon
    
    return icon
      .onTapGesture {
        selectedItemTag = item.tag
      }
  }
}
