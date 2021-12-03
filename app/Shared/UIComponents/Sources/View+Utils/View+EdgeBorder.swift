//
//  View+EdgeBorder.swift
//  
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI

extension View {
    
    /// Applies border to the specified edges.
    ///
    /// - Parameters:
    ///   - width: The thickness of the border; if not provided, the default is 1 pixel.
    ///   - edges: The alignment for border in relation to this view.
    ///   - color: Sets the color of the border.
    public func border(width: CGFloat = 1, edges: Set<Edge>, color: Color) -> some View {
        overlay(Group {
            if edges.contains(.top) {
                Divider().frame(height: width).background(color)
            }
        }, alignment: .top)
            .overlay(Group {
                if edges.contains(.bottom) {
                    Divider().frame(height: width).background(color)
                }
            }, alignment: .bottom)
            .overlay(Group {
                if edges.contains(.leading) {
                    Divider().frame(height: width).background(color)
                }
            }, alignment: .leading)
            .overlay(Group {
                if edges.contains(.trailing) {
                    Divider().frame(height: width).background(color)
                }
            }, alignment: .trailing)
    }
}
