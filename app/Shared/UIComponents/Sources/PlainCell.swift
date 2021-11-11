//
//  PlainCell.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-09.
//

import SwiftUI

/// A full width view that houses any content and adds a rounded black border and white background
struct PlainCell<Content: View>: View {
    
    /// A generic view for the content of the cell
    var content: Content
    
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
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black, lineWidth: 2.0)
        }
    }
}
