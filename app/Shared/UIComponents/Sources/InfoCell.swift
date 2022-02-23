//
//  InfoCell.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-15.
//

import SwiftUI

public struct InfoCell<Icon: View, SupplementaryView: View, Accessory: View>: View {
  
  /// The icon on the left of the information cell
  private let icon: Icon
  
  /// The main text for the information cell
  private let text: String
  
  /// An optional callout icon view
  private let supplementaryView: SupplementaryView?
  
  /// An optional accessory icon view
  private let accessory: Accessory?
  
  /// An tap action for when the information cell is tapped
  private let action: (() -> Void)?
  
  /// Initializes an information cell with a left icon, some text, a callout string and icon, an accessory view, and optional tap action
  ///
  /// ```swift
  /// InfoCell(
  ///   text: "Info cell text",
  ///   icon: { Image.holder },
  ///   supplementaryView: {
  ///     Text("Supplemetary View")
  ///       .padding(.leading, 5)
  ///   },
  ///   accessory: {
  ///     Image.mdArrowRight
  ///   },
  ///   action: {
  ///     isActivityPresented.toggle()
  ///   })
  /// ```
  ///
  /// - Parameters:
  ///   - text: The main text for the information cell
  ///   - icon: The icon on the left of the information cell
  ///   - supplementaryView: An optional supplementary view, appearing on the right side of the main `text` label
  ///   - accessory: An optional accessory icon view
  ///   - action: An tap action for when the information cell is tapped
  public init(
    text: String,
    @ViewBuilder icon: () -> Icon,
    @ViewBuilder supplementaryView: () -> SupplementaryView,
    @ViewBuilder accessory: () -> Accessory,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon()
    self.text = text
    self.supplementaryView = supplementaryView()
    self.accessory = accessory()
    self.action = action
  }
  
  /// Initializes an information cell with a left icon, some text, a callout string and icon, and optional tap action
  ///
  /// ```swift
  /// InfoCell(text: "Held by", calloutText: "beautifulpunks.eth", icon: {
  ///    Image.holder
  ///     .resizable()
  ///     .aspectRatio(contentMode: .fit)
  ///     .frame(width: 35, height: 35, alignment: .center)
  /// }, supplememtaryView: {
  ///     Image.eth
  /// ), action: {
  ///     isActivityPresented.toggle()
  /// })
  /// ```
  ///
  /// - Parameters:
  ///   - text: The main text for the information cell
  ///   - icon: The icon on the left of the information cell
  ///   - supplementaryView: An optional supplementary view, appearing on the right side of the main `text` label
  ///   - action: An tap action for when the information cell is tapped
  public init(
    text: String,
    @ViewBuilder icon: () -> Icon,
    @ViewBuilder supplementaryView: () -> SupplementaryView,
    action: (() -> Void)? = nil
  ) where Accessory == EmptyView {
    self.icon = icon()
    self.text = text
    self.supplementaryView = supplementaryView()
    self.accessory = nil
    self.action = action
  }
  
  /// Initializes an information cell with a left icon, some text, a callout string, an accessory view, and optional tap action
  ///
  /// ```swift
  /// InfoCell(text: "Held by", calloutText: "beautifulpunks.eth", icon: {
  ///   Image.holder
  /// }, accessory: {
  ///   Image.mdArrowRight
  /// }, action: {
  ///   isActivityPresented.toggle()
  /// })
  /// ```
  ///
  /// - Parameters:
  ///   - text: The main text for the information cell
  ///   - icon: The icon on the left of the information cell
  ///   - accessory: An optional accessory icon view
  ///   - action: An tap action for when the information cell is tapped
  public init(
    text: String,
    @ViewBuilder icon: () -> Icon,
    @ViewBuilder accessory: () -> Accessory,
    action: (() -> Void)? = nil
  ) where SupplementaryView == EmptyView {
    self.icon = icon()
    self.text = text
    self.accessory = accessory()
    self.supplementaryView = nil
    self.action = action
  }
  
  /// Initializes an information cell with a left icon, some text, a callout string, and optional tap action
  ///
  /// ```swift
  /// InfoCell(text: "Held by", icon: {
  ///    Image.holder
  ///     .resizable()
  ///  }, action: {
  ///    isActivityPresented.toggle()
  ///  })
  /// ```
  ///
  /// - Parameters:
  ///   - icon: The icon on the left of the information cell
  ///   - text: The main text for the information cell
  ///   - calloutText: An optional callout text property, which displays text after the main text in a bold font
  ///   - tapAction: An tap action for when the information cell is tapped
  public init(
    text: String,
    @ViewBuilder icon: () -> Icon,
    action: (() -> Void)? = nil
  ) where Accessory == EmptyView, SupplementaryView == EmptyView {
    self.icon = icon()
    self.text = text
    self.supplementaryView = nil
    self.accessory = nil
    self.action = action
  }
  
  public var body: some View {
    Label {
      HStack(spacing: 0) {
        Text(text)
          .font(.custom(.regular, relativeTo: .subheadline))
        
        supplementaryView
        
        Spacer()
        
        accessory
      }
    } icon: {
      icon
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action?()
    }
  }
}
