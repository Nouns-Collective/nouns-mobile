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

/// A full width view that houses any content and adds a rounded black border and white background
public struct PlainCell<Content: View>: View {
    
    @Environment(\.loading) private var isLoading
    
    /// A generic view for the content of the cell
    var content: Content
    
    /// The background color of the cell
    let background: Color?
    
    /// The border color of the cell
    let borderColor: Color
    
    /// The edges to apply padding to
    let edges: Edge.Set
    
    /// The size of the padding
    let length: CGFloat?
    
    /// Initializes a plain cell with any content view
    ///
    /// ```swift
    ///     PlainCell {
    ///         VStack(alignment: .leading, spacing: 14) {
    ///             HStack(alignment: .center) {
    ///                 Label("Approved", systemImage: "checkmark")
    ///                     .contained(textColor: .white, backgroundColor: .blue)
    ///                     .labelStyle(.titleAndIcon(spacing: 3))
    ///                     .font(Font.caption.bold())
    ///                 Spacer()
    ///                 Text("Proposal 14 • Passed")
    ///                     .font(Font.caption.weight(.semibold))
    ///                     .opacity(0.5)
    ///             }
    ///
    ///             Text("Brave Sponsored Takeover during NFT NYC")
    ///                 .fontWeight(.semibold)
    ///         }
    ///     }.padding()
    /// ```
    ///
    /// - Parameters:
    ///   - content: A view for the cell
    public init(
        edges: Edge.Set = .all,
        length: CGFloat? = 0,
        background: Color? = Color.white,
        borderColor: Color = Color.black,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.edges = edges
        self.length = length
        self.borderColor = borderColor
        self.background = background
    }
    
    public var body: some View {
        VStack {
            content
        }
        .padding(edges, length)
        .frame(maxWidth: .infinity)
        .background(background ?? Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
          RoundedRectangle(cornerRadius: 12)
              .stroke(borderColor, lineWidth: 2.0)
        }
        .opacity(isLoading ? 0.05 : 1.0)
    }
}
