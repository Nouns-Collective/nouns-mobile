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
struct OutlineTabItemSelectionChange: PreferenceKey {
    static var defaultValue: Int = 0

    static func reduce(value: inout Int, nextValue: () -> Int) {
        value = nextValue()
    }
}

// TODO: Set `Tag` to conform to `Hashable`
struct OutlineTabItem: Hashable, Identifiable {
    let id = UUID()
    let icon: String
    let tag: Int
}

internal struct OutlineTabBar: View {
    @Environment(\.outlineTabItemSelection) private var selection
    @State private var isSelected = false
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
    }
    
    private func tabItem(_ item: OutlineTabItem) -> some View {
        Image(item.icon, bundle: .module)
            .preference(
                key: OutlineTabItemSelectionChange.self,
                value: (isSelected ? item.tag : selection)
            )
            .onTapGesture {
                withAnimation(.spring(blendDuration: 0.05)) {
                    isSelected = true
                }
            }
            .onChange(of: selection) { newValue in
                if newValue != item.tag {
                    isSelected = false
                }
            }
            .onAppear {
                isSelected = (selection == item.tag)
            }
    }
}

extension View {
    
    public func outlineTabItem(_ icon: String, tag: Int) -> some View {
        preference(
            key: OutlineTabItems.self,
            value: [OutlineTabItem(icon: icon, tag: tag)])
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
        .onPreferenceChange(OutlineTabItemSelectionChange.self) { newSelectedTabItem in
            selection = newSelectedTabItem
        }
    }
}

struct OutlineTabView_preview: PreviewProvider {
    
    static var previews: some View {
        OutlineTabView(selection: .constant(0)) {
            Gradient.cherrySunset
                .outlineTabItem("explore-outline", tag: 0)
            
            Gradient.bubbleGum
                .outlineTabItem("create-outline", tag: 1)
            
            Gradient.lemonDrop
                .outlineTabItem("play-outline", tag: 2)
            
            Gradient.orangesicle
                .outlineTabItem("settings-outline", tag: 3)
        }
    }
}
