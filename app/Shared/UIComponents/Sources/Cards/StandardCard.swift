//
//  StandardCard.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

/// A label style that shows both the title and icon of the label using a
/// system-standard layout with spacing.
public struct TitleAndIconLabelSpacedStyle: LabelStyle {
    let spacing: CGFloat
    
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            Spacer().frame(width: spacing)
            configuration.title
        } icon: {
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TitleAndIconLabelSpacedStyle {
    
    /// A label style that shows both the title and icon of the label using a
    /// system-standard layout with a spacing.
    ///
    /// In most cases, labels show both their title and icon by default. However,
    /// some containers might apply a different default label style to their
    /// content, such as only showing icons within toolbars on macOS and iOS. To
    /// opt in to showing both the title and the icon, you can apply the title
    /// and icon label style:
    ///
    ///     Label("Lightning", systemImage: "bolt.fill")
    ///         .labelStyle(.titleAndIcon(spacing: 20))
    ///
    /// To apply the title and icon style to a group of labels, apply the style
    /// to the view hierarchy that contains the labels:
    ///
    ///     VStack {
    ///         Label("Rain", systemImage: "cloud.rain")
    ///         Label("Snow", systemImage: "snow")
    ///         Label("Sun", systemImage: "sun.max")
    ///     }
    ///     .labelStyle(.titleAndIcon(spacing: 20))
    ///
    /// - Parameter spacing: The distance between adjacent the title and icon.
    ///
    public static func titleAndIcon(spacing: CGFloat) -> Self {
        TitleAndIconLabelSpacedStyle(spacing: spacing)
    }
}

public struct StandardCard<Media: View, Label: View>: View {
    
    /// The large media content appearing at the top of the card
    let media: Media
    
    /// A user-set label view for the bottom of the card, beneath the media content
    let label: Label
    
    
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
        @ViewBuilder label: () -> Label
    ) {
        self.media = media()
        self.label = label()
    }
    
    /// Initializes a card with any view for the media, but with a StandardCardFooter for the label
    ///
    ///  ```swift
    ///  StandardCard(media: {
    ///     Rectangle()
    ///         .fill(Color.red)
    ///  }, header: "Noun 64", subheader: "Oct 04 2021",
    ///     detail: "bob.eth", detailSubheader: "Winner")
    ///  ```
    ///
    /// - Parameters:
    ///   - media: A view for the media portion of the card (top)
    ///   - header: The header text, located on the top left of the footer
    ///   - subheader: The subheader text, located on the bottom left of the footer (beneath the header)
    ///   - detail: The detail text, located on the top right of the footer
    ///   - detailSubheader: The detail's subheader, located on the bottom right of the footer
    public init (
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
    
    public var body: some View {
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

///
public struct StandardCardFooter: View {
    
    /// The header text, located on the top left of the footer
    let header: String
    
    /// The subheader text, located on the bottom left of the footer (beneath the header)
    let subheader: String
    
    /// The detail text, located on the top right of the footer
    let detail: String
    
    /// The detail's subheader, located on the bottom right of the footer
    let detailSubheader: String
    
    public var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(header)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(subheader)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(detail)
                    .fontWeight(.medium)
                
                Text(detailSubheader)
                    .font(.caption)
            }
        }
    }
}
