//
//  StandardCard.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

struct StandardCard<Media: View, Label: View>: View {
    
    /// The large media content appearing at the top of the card
    let media: Media
    
    /// A user-set label view for the bottom of the card, beneath the media content
    let label: Label
    
    
    /// Initializes a card with any view for the media and the label (footer)
    ///
    ///
    /// - Parameters:
    ///   - media: A view for the media portion of the card (top)
    ///   - label: A view for the label/footer portion of the card (bottom)
    @inlinable public init(
        @ViewBuilder media: () -> Media,
        @ViewBuilder label: () -> Label
    ) {
        self.media = media()
        self.label = label()
    }
    
    /// Initializes a card with any view for the media, but with a StandardCardFooter for the label
    ///
    ///
    /// - Parameters:
    ///   - media: A view for the media portion of the card (top)
    ///   - header: The header text, located on the top left of the footer
    ///   - subheader: The subheader text, located on the bottom left of the footer (beneath the header)
    ///   - detail: The detail text, located on the top right of the footer
    ///   - detailSubheader: The detail's subheader, located on the bottom right of the footer
    @inlinable public init (
        @ViewBuilder media: () -> Media,
        header: String,
        subheader: String,
        detail: String,
        detailSubheader: String
    ) where Label == StandardCardFooter {
        self.media = media()
        self.label = {
            return StandardCardFooter(header: header, subheader: subheader, detail: detail, detailSubheader: detailSubheader)
        }()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            media
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                .background(Color(uiColor: UIColor.lightGray.withAlphaComponent(0.2)))
            
            label
                .padding(20)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 15)
        .padding(.horizontal, 20)
    }
}

struct StandardCard_Previews: PreviewProvider {
    static var previews: some View {
        StandardCard {
            Rectangle()
                .fill(Color.red)
        } label: {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("Noun 64")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Oct 04 2021")
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("bob.eth")
                        .fontWeight(.medium)
                    
                    Text("Winner")
                        .font(.caption)
                }
            }
        }
        
        StandardCard(media: {
            Rectangle()
                .fill(Color.red)
        }, header: "Noun 64", subheader: "Oct 04 2021", detail: "bob.eth", detailSubheader: "Winner")
    }
}
