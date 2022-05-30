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
  
  /// Boolean value to determine if there should a dimming view between the bottom sheet and the Content
  var showDimmingView: Bool
  
  /// Minimum distance between the top of the sheet and the top of the screen
  var minTopDistance: CGFloat
  
  /// Inits the style
  ///
  /// - Parameters:
  ///   - showDimmingView: If the background cover is shown (behind the sheet)
  ///   - minTopDistance: Minimum distance between the top of the sheet and the top of the screen
  public init(showDimmingView: Bool = true,
              minTopDistance: CGFloat = 110
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
