//
//  PlainCell.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-09.
//

import SwiftUI

/// A full width view that houses any content and adds a rounded black border and white background
public struct PlainCell<Content: View>: View {
    
    @Environment(\.loading) private var isLoading
    
    /// A generic view for the content of the cell
    var content: Content
    
    /// The background color of the cell
    let background: Color?
    
    /// The border color of the cell
    let borderColor: Color?
    
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
        borderColor: Color? = Color.black,
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
            if let borderColor = borderColor {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2.0)
            }
        }
        .opacity(isLoading ? 0.05 : 1.0)
    }
}
