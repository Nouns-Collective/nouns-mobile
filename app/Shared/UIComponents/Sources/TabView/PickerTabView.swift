//
//  PickerTabView.swift
//  
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI

/// Accessing the current selected tab in the environment.
private struct PickerTabItemSelection: EnvironmentKey {
    static var defaultValue: Int = 0
}

extension EnvironmentValues {
    
    fileprivate var pickerTabItemSelection: Int {
        get { self[PickerTabItemSelection.self] }
        set { self[PickerTabItemSelection.self] = newValue }
    }
}

// TODO: Set `Tag` to conform to `Hashable`
private struct PickerTabItem: Hashable, Identifiable {
    let id = UUID()
    // TODO: title should conform to `View`.
    let title: String
    let tag: Int
}

/// Access all the items set by the client through the view modifier.
private struct PickerTabItems: PreferenceKey {
    static var defaultValue: [PickerTabItem] = []
    static func reduce(value: inout [PickerTabItem], nextValue: () -> [PickerTabItem]) {
        value += nextValue()
    }
}

private struct PickerTabContent: ViewModifier {
    @Environment(\.pickerTabItemSelection) private var selection
    private let tag: Int
    
    init(
        tag: Int
    ) {
        self.tag = tag
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tag ? 1 : 0)
    }
}

extension View {
    
    /// Sets the tab bar item associated with this view.
    /// - Parameters:
    ///   - tag: Sets the unique tag value of this view.
    public func pickerTabContent(_ title: String, tag: Int) -> some View {
        modifier(PickerTabContent(tag: tag))
            .preference(
                key: PickerTabItems.self,
                value: [PickerTabItem(title: title, tag: tag)])
    }
}

public struct PickerTabView<Content>: View where Content: View {
    @Namespace private var slideActiveTabSpace
    @Binding private var selection: Int
    @State private var items: [PickerTabItem] = []
    private let content: Content
    
    public init(
        selection: Binding<Int>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            content
                .ignoresSafeArea()
            
            OutlinePicker(selection: $selection) {
                ForEach(items) { item in
                    Text(item.title)
                        .pickerItemTag(item.tag, namespace: slideActiveTabSpace)
                }
            }
        }
        .environment(\.pickerTabItemSelection, selection)
        .onPreferenceChange(PickerTabItems.self) { items in
            self.items = items
        }
    }
}

struct PickerTabView_Preview: PreviewProvider {
    
    struct Example: View {
        @State var selection: Int = 0
        
        var body: some View {
            PickerTabView(selection: $selection) {
                Gradient.cherrySunset
                    .pickerTabContent("Activities", tag: 0)
                
                Gradient.lemonDrop
                    .pickerTabContent("Big history", tag: 1)
            }
        }
    }
    
    static var previews: some View {
        Example()
            .onAppear {
                UIComponents.configure()
            }
    }
}
