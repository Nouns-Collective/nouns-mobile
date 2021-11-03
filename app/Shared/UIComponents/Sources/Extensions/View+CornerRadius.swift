//
//  View+CornerRadius.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-02.
//

import SwiftUI

extension View {
    /// Applies a corner radius to any specified set of corners to any view
    ///
    ///
    /// - Parameters:
    ///   - radius: The desired corner radius for the view
    ///   - corners: The corners to apply the corner radius too, exclusively. 
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
