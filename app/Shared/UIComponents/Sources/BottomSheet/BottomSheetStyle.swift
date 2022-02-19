//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-31.
//

import SwiftUI

public struct BottomSheetStyle {

    /// A fixed color for the dimming view
    static let dimmingViewColor = Color.black.opacity(0.2)
    
    /// Tells if should be there a cover between the Partial Sheet and the Content
    var showDimmingView: Bool

    /// Minimum distance between the top of the sheet and the top of the screen
    var minTopDistance: CGFloat
  
    /// Inits the style
    ///
    /// - Parameters:
    ///   - showDimmingView: If the background cover is shown (behind the sheet)
    ///   - dimmingViewColor: The background cover color
    ///   - cornerRadius: The corner radius for the sheet
    ///   - minTopDistance: Minimum distance between the top of the sheet and the top of the screen
    public init(showDimmingView: Bool,
                minTopDistance: CGFloat
    ) {
        self.showDimmingView = showDimmingView
        self.minTopDistance = minTopDistance
    }
}

extension BottomSheetStyle {

    /** A default Style for the BottomSheet with system colors.

     - showDimmingView: true
     - minTopDistance: 110
     */
    public static func defaultStyle() -> BottomSheetStyle {
        return BottomSheetStyle(showDimmingView: true,
                                minTopDistance: 110)
    }
}
