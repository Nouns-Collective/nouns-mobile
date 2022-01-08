//
//  CoachmarkTool.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-25.
//

import SwiftUI

public struct CoachmarkTool<Icon: View>: View {
    
    /// The title of the coachmark tool, residing below the icon image
    private let title: String
    
    /// The icon of the coachmark tool, residing above the title
    private let icon: () -> Icon
    
    /// Initializes a coachmark tool with a title and an icon image
    ///
    /// ```swift
    /// CoachmarkTool("Shake to shuffle", image: Image.shakePhone)
    /// ```
    ///
    /// - Parameters:
    ///   - title: The text for the coachmark tool, presented underneath the icon image
    ///   - image: The icon image for the coachmark tool, presented above the title text
    public init(_ title: String, image: Image) where Icon == AnyView {
        self.title = title
        self.icon = {
            AnyView(image
                .resizable()
                .scaledToFit())
        }
    }
    
    /// Initializes a coachmark tool with a title and any view
    ///
    /// ```swift
    /// CoachmarkTool("Shake to shuffle", iconView: { Image.shakePhone })
    /// ```
    ///
    /// - Parameters:
    ///   - title: The text for the coachmark tool, presented underneath the icon image
    ///   - iconView: The icon image for the coachmark tool, presented above the title text
    public init(_ title: String, @ViewBuilder iconView: @escaping () -> Icon) {
        self.title = title
        self.icon = iconView
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 16) {
            icon()
                .frame(width: 32, height: 32, alignment: .center)
            
            Text(title)
                .font(.custom(.medium, size: 17))
                .foregroundColor(Color.componentNounsBlack)
        }
    }
}
