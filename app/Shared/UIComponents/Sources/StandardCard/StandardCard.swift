//
//  StandardCard.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

public enum CardFont {
    case large
    case small
    case custom(font: Font)
    
    var font: Font {
        switch self {
        case .large:
            return Font.custom(.bold, size: 36)
        case .small:
            return Font.custom(.bold, size: 21)
        case .custom(let font):
            return font
        }
    }
}

private struct StandardCardHeaderStyle: EnvironmentKey {
    static let defaultValue = CardFont.large
}

private extension EnvironmentValues {
  var standardCardHeaderStyle: CardFont {
    get { self[StandardCardHeaderStyle.self] }
    set { self[StandardCardHeaderStyle.self] = newValue }
  }
}

public struct StandardCard<HeaderString: StringProtocol, Media: View, Accessory: View, Content: View>: View {
    
    @Environment(\.standardCardHeaderStyle) private var headerStyle
    @Environment(\.loading) private var isLoading
    
    private let header: HeaderString
    
    private let accessory: Accessory
    
    /// The large media content appearing at the top of the card
    private let media: Media
    
    /// A user-set label view for the bottom of the card, beneath the media content
    private let content: Content
    
    /// Initializes a card with any view for the media and the label (footer)
    ///
    /// ```swift
    ///  StandardCard(header: "Header", accessory: {
    ///     Image.mdArrowCorner
    ///         .resizable()
    ///         .scaledToFit()
    ///         .frame(width: 24, height: 24, alignment: .center)
    ///  }, media: {
    ///     Color.gray
    ///         .frame(height: 400)
    ///  }, content: {
    ///     HStack {
    ///         CompoundLabel(Text("Some Text"), icon: Image.currentBid, caption: "Current Bid")
    ///
    ///         Spacer()
    ///
    ///         CompoundLabel(Text("Some Text"), icon: Image.currentBid, caption: "Current Bid")
    ///
    ///         Spacer()
    ///     }
    ///     .padding(.top, 20)
    ///  })
    ///  .headerStyle(.large)
    ///  .padding()
    /// ```
    ///
    /// - Parameters:
    ///   - header: A string for the header label of the card
    ///   - accessory: An optional accessory image for the top right of the card
    ///   - media: The main rich media component of the card
    ///   - content: The body of the card, below the header
    public init(
        header: HeaderString,
        @ViewBuilder accessory: () -> Accessory,
        @ViewBuilder media: () -> Media,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.accessory = accessory()
        self.media = media()
        self.content = content()
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
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(header)
                        .font(headerStyle.font)
                        .redactable(style: .skeleton)
                    
                    Spacer()
                    
                    accessory
                }
                
                content
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 2)
        }
        .opacity(isLoading ? 0.05 : 1.0)
    }
}

public extension StandardCard {
  func headerStyle(_ font: CardFont) -> some View {
    environment(\.standardCardHeaderStyle, font)
  }
}
