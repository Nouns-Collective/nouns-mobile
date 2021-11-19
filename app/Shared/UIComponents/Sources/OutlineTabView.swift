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

// TODO: Set `Tag` to conform to `Hashable`
struct OutlineTabItem: Hashable, Identifiable {
    let id = UUID()
    let icon: String
    let tag: Int
}

struct OutlineTabItems: PreferenceKey {
    static var defaultValue: [OutlineTabItem] = []
    static func reduce(value: inout [OutlineTabItem], nextValue: () -> [OutlineTabItem]) {
        value += nextValue()
    }
}

internal struct OutlineTabBar: View {
    @Environment(\.outlineTabItemSelection) private var selection
    private let items: [OutlineTabItem]
    
    internal init(_ items: [OutlineTabItem]) {
        self.items = items
    }
    
    internal var body: some View {
        HStack {
            ForEach(items) { item in
                Image(item.icon, bundle: .module)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 20)
        .padding(0)
        .border(.black, width: 2)
        .background(Color.white)
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
    }
}

struct OutlineTabView_preview: PreviewProvider {
    
    static var previews: some View {
        OutlineTabView(selection: .constant(0)) {
            Gradient.cherrySunset
                .outlineTabItem("explore-outline", tag: 0)
            
            Gradient.bubbleGum
                .outlineTabItem("create-outline", tag: 0)
            
            Gradient.lemonDrop
                .outlineTabItem("play-outline", tag: 0)
            
            Gradient.orangesicle
                .outlineTabItem("settings-outline", tag: 0)
        }
    }
}

