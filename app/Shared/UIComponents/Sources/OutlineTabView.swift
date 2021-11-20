//
//  OutlineTabView.swift
//
//
//  Created by Ziad Tamim on 19.11.21.
//

import SwiftUI

/// Accessing the current selected tab in the environment.
struct OutlineTabItemSelection: EnvironmentKey {
    static var defaultValue: Int = 0
}

extension EnvironmentValues {
    var outlineTabItemSelection: Int {
        get { self[OutlineTabItemSelection.self] }
        set { self[OutlineTabItemSelection.self] = newValue }
    }
}

/// Access all the items set by the client through the view modifier.
struct OutlineTabItems: PreferenceKey {
    static var defaultValue: [OutlineTabItem] = []
    static func reduce(value: inout [OutlineTabItem], nextValue: () -> [OutlineTabItem]) {
        value += nextValue()
    }
}

/// Accessing the newly selected tab triggered by child views.
struct OutlineTabItemSelectionDidChange: PreferenceKey {
    static var defaultValue: Int = 0
    static func reduce(value: inout Int, nextValue: () -> Int) {
        value += nextValue()
    }
}

// TODO: Set `Tag` to conform to `Hashable`
struct OutlineTabItem: Hashable, Identifiable {
    let id = UUID()
    let normalStateIcon: String
    let selectedStateIcon: String
    let tag: Int
}

internal struct OutlineTabBar: View {
    @Environment(\.outlineTabItemSelection) private var selection
    @State private var selectedItemTag = 0
    private let items: [OutlineTabItem]
    
    internal init(_ items: [OutlineTabItem]) {
        self.items = items
    }
    
    internal var body: some View {
        HStack {
            ForEach(items) { item in
                tabItem(item)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 20)
        .padding(0)
        .border(.black, width: 2)
        .background(Color.white)
        .clipShape(Rectangle())
    }
    
    private func tabItem(_ item: OutlineTabItem) -> some View {
        var isSelected: Bool {
            selectedItemTag == item.tag
        }
        return Image(isSelected ? item.selectedStateIcon : item.normalStateIcon,
              bundle: .module)
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

struct OutlineTabContent: ViewModifier {
    @Environment(\.outlineTabItemSelection) private var selection
    private let tag: Int
    
    init(_ tag: Int) {
        self.tag = tag
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tag ? 1 : 0)
    }
}

extension View {
    
    public func outlineTabItem(normal: String, selected: String, tag: Int) -> some View {
        modifier(OutlineTabContent(tag))
            .preference(
                key: OutlineTabItems.self,
                value: [OutlineTabItem(normalStateIcon: normal,
                                       selectedStateIcon: selected,
                                       tag: tag)])
    }
}

public struct OutlineTabView<Content>: View where Content: View {
    @Binding private var selection: Int
    @State private var items: [OutlineTabItem] = []
    private let content: Content
    
    public init(selection: Binding<Int>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._selection = selection
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            OutlineTabBar(items)
        }
        .environment(\.outlineTabItemSelection, selection)
        .onPreferenceChange(OutlineTabItems.self) { items in
            self.items = items
        }
        .onPreferenceChange(OutlineTabItemSelectionDidChange.self) { newSelectedTabItem in
            selection = newSelectedTabItem
        }
    }
}

struct OutlineTabView_preview: PreviewProvider {
    
    struct Example: View {
        @State var selection: Int = 0
        
        var body: some View {
            OutlineTabView(selection: $selection) {
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
    
    static var previews: some View {
        Example()
    }
}
