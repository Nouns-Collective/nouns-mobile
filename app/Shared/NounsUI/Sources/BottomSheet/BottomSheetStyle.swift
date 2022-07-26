// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
