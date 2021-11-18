//
//  StandardCard.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

public struct StandardCard<Media: View, Label: View>: View {
    @Environment(\.loading) private var isLoading
    
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
    
    /// Initializes a card with any view for the media and a StandardCardFooter for the label
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
    public init<LeftDetailView, RightDetailView>(
        @ViewBuilder media: () -> Media,
        header: String,
        accessoryImage: Image,
        @ViewBuilder leftDetail: () -> LeftDetailView,
        @ViewBuilder rightDetail: () -> RightDetailView,
        roundedCorners: UIRectCorner = [.allCorners]
    ) where LeftDetailView: View, RightDetailView: View, Label == StandardCardFooter<LeftDetailView, RightDetailView> {
        self.media = media()
        self.label = {
            return StandardCardFooter(header: header, accessoryImage: accessoryImage, leftDetail: leftDetail(), rightDetail: rightDetail())
        }()
        self.roundedCorners = roundedCorners
    }
    
    /// Initializes a card with any view for the media and a SmallCardFooter for the label
    ///
    ///  ```swift
    ///  StandardCard(media: {
    ///      Rectangle()
    ///          .fill(Color.gray.opacity(0.2))
    ///          .frame(height: 200)
    ///  }, smallHeader: "Noun 64", accessoryImage: Image(systemName: "arrow.up.right")) {
    ///      CardDetailView(header: "89.00", headerIcon: Image(systemName: "dollarsign.circle"), subheader: nil)
    ///  }
    ///  ```
    ///
    /// - Parameters:
    ///   - media: A view for the media portion of the card (top)
    ///   - smallHeader: The small header text, located on the top left of the footer
    ///   - accessoryImage: A small image to display next to the header
    ///   - detail: A card detail view for the bottom left of the card
    public init<DetailView>(
        @ViewBuilder media: () -> Media,
        smallHeader: String,
        accessoryImage: Image,
        @ViewBuilder detail: () -> DetailView,
        roundedCorners: UIRectCorner = [.allCorners]
    ) where DetailView: View, Label == SmallCardFooter<DetailView> {
        self.media = media()
        self.label = {
            return SmallCardFooter(header: smallHeader, accessoryImage: accessoryImage, detail: detail())
        }()
        self.roundedCorners = roundedCorners
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            media
                .background(Color.componentSoftGrey)
                .opacity(isLoading ? 0 : 1)
                .overlay {
                    ZStack {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                        
                        if isLoading {
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                        }
                    }
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
        .opacity(isLoading ? 0.05 : 1.0)
    }
}

///
public struct StandardCardFooter<LeftDetailView: View, RightDetailView: View>: View {
    /// The header text, located on the top left of the footer
    let header: String
    
    /// A large image to display next to the header
    let accessoryImage: Image
    
    /// A card detail view for the bottom left of the card
    let leftDetail: LeftDetailView
    
    /// ThA card detail view for the bottom right of the card
    let rightDetail: RightDetailView
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack(alignment: .center) {
                Text(header)
                    .font(Font.custom(.bold, relativeTo: .title2))
                    .skeletonWhenRedacted()
                
                Spacer()
                
                accessoryImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35, alignment: .center)
            }
            
            HStack(alignment: .bottom) {
                HStack {
                    leftDetail
                        .skeletonWhenRedacted()
                    Spacer()
                }
                
                HStack {
                    rightDetail
                        .skeletonWhenRedacted()
                    Spacer()
                }
            }
        }
    }
}

public struct SmallCardFooter<DetailView: View>: View {
    /// The small header text, located on the top left of the footer
    let header: String
    
    /// A small image to display next to the header
    let accessoryImage: Image
    
    /// A small card detail view for the bottom of the card
    let detail: DetailView
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center) {
                Text(header)
                    .font(Font.custom(.bold, relativeTo: .body))
                    .skeletonWhenRedacted()

                Spacer()
                
                accessoryImage
            }
            
            detail
                .skeletonWhenRedacted()
        }
    }
}

struct Preview: PreviewProvider {
    struct PreviewView: View {
        init() {
            UIComponents.configure()
        }
        
        var body: some View {
            StandardCard(media: {
                Color.gray
                    .frame(height: 400)
            }, header: "Header", accessoryImage: Image.mdArrowCorner, leftDetail: {
                CompoundLabel(Text("Some Text"), icon: Image.currentBid, caption: "Current Bid")
            }, rightDetail: {
                CompoundLabel(Text("Some Text"), icon: Image.currentBid, caption: "Current Big")
            }).padding()
            .loading()
        }
    }
    
    struct PreviewSmallCardView: View {
        init() {
            UIComponents.configure()
        }
        
        var body: some View {
            StandardCard(media: {
                Color.gray
                    .frame(height: 250)
            }, smallHeader: "Header", accessoryImage: Image.mdArrowCorner, detail: {
                SafeLabel("89.00", icon: Image.eth)
            }).padding()
            .frame(width: 300)
            .loading()
        }
    }
    
    static var previews: some View {
        PreviewView()
        PreviewSmallCardView()
    }
}
