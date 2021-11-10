//
//  StandardCard.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

public struct CardDetailView: View {
    
    /// The string for the bold header of the detail view
    let header: String
    
    /// An icon to display next to the header  (optional)
    let headerIcon: Image?
    
    /// The string for the light caption text underneath the header in the detail view
    let subheader: String
    
    public var body: some View {
        VStack(alignment: .leading) {
            Label {
                HStack {
                    Spacer().frame(width: headerIcon == nil ? 0 : 2)
                    Text(header)
                        .font(Font.custom(.bold, relativeTo: .footnote))
                }
            } icon: {
                headerIcon?
                    .font(Font.body.bold())
            }.labelStyle(.titleAndIcon(spacing: 0))
            
            Text(subheader)
                .font(Font.custom(.regular, relativeTo: .footnote))
        }
    }
}

public struct StandardCard<Media: View, Label: View>: View {
    
    /// The large media content appearing at the top of the card
    private let media: Media
    
    /// A user-set label view for the bottom of the card, beneath the media content
    private let label: Label
    
    /// A set of corners to apply a rounded corner radius to
    private let roundedCorners: UIRectCorner
    
    /// Initializes a card with any view for the media and the label (footer)
    ///
    /// ```swift
    ///  StandardCard {
    ///      Rectangle()
    ///        .fill(Color.red)
    ///
    ///  } label: {
    ///      HStack(alignment: .bottom) {
    ///         VStack(alignment: .leading) {
    ///              Text("Noun 64")
    ///                 .font(.title2)
    ///                 .fontWeight(.semibold)
    ///
    ///              Text("Oct 04 2021")
    ///                 .font(.caption)
    ///         }
    ///
    ///         Spacer()
    ///
    ///         VStack(alignment: .leading) {
    ///             Text("bob.eth")
    ///                 .fontWeight(.medium)
    ///
    ///             Text("Winner")
    ///                 .font(.caption)
    ///         }
    ///  }
    /// ```
    ///
    /// - Parameters:
    ///   - media: A view for the media portion of the card (top)
    ///   - label: A view for the label/footer portion of the card (bottom)
    public init(
        @ViewBuilder media: () -> Media,
        @ViewBuilder label: () -> Label,
        roundedCorners: UIRectCorner = [.allCorners]
    ) {
        self.media = media()
        self.label = label()
        self.roundedCorners = roundedCorners
    }
    
    /// Initializes a card with any view for the media, but with a StandardCardFooter for the label
    ///
    ///  ```swift
    ///  StandardCard(media: {
    ///      Rectangle()
    ///          .fill(Color.gray.opacity(0.2))
    ///          .frame(height: 400)
    ///  }, header: "Noun 64", accessoryImage: Image(systemName: "arrow.up.right")) {
    ///      CardDetailView(header: "4h 17m 23s", headerIcon: nil, subheader: "Remaining")
    ///  } rightDetail: {
    ///      CardDetailView(header: "89.00", headerIcon: Image(systemName: "dollarsign.circle"), subheader: "Current bid")
    ///  }
    ///  ```
    ///
    /// - Parameters:
    ///   - media: A view for the media portion of the card (top)
    ///   - header: The header text, located on the top left of the footer
    ///   - accessoryImage: A large image to display next to the header
    ///   - leftDetail: A card detail view for the bottom left of the card
    ///   - rightDetail: A card detail view for the bottom right of the card
    public init (
        @ViewBuilder media: () -> Media,
        header: String,
        accessoryImage: Image,
        @ViewBuilder leftDetail: () -> CardDetailView,
        @ViewBuilder rightDetail: () -> CardDetailView,
        roundedCorners: UIRectCorner = [.allCorners]
    ) where Label == StandardCardFooter {
        self.media = media()
        self.label = {
            return StandardCardFooter(header: header, accessoryImage: accessoryImage, leftDetail: leftDetail(), rightDetail: rightDetail())
        }()
        self.roundedCorners = roundedCorners
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            media
                .background(Color(uiColor: UIColor.lightGray.withAlphaComponent(0.2)))
                .overlay {
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                }
            
            label
                .padding(20)
        }
        .background(Color.white)
        .cornerRadius(12, corners: roundedCorners)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 2)
        }
        .padding(.horizontal, 20)
    }
}

///
public struct StandardCardFooter: View {
    
    /// The header text, located on the top left of the footer
    let header: String
    
    /// A large image to display next to the header
    let accessoryImage: Image
    
    /// A card detail view for the bottom left of the card
    let leftDetail: CardDetailView
    
    /// ThA card detail view for the bottom right of the card
    let rightDetail: CardDetailView
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack(alignment: .top) {
                Text(header)
                    .font(Font.custom(.bold, relativeTo: .title2))
                
                Spacer()
                
                accessoryImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25, alignment: .top)
            }
            
            HStack(alignment: .bottom) {
                HStack {
                    leftDetail
                    Spacer()
                }
                
                HStack {
                    rightDetail
                    Spacer()
                }
            }
        }
    }
}
