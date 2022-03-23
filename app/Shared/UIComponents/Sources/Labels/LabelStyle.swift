//
//  LabelStyle.swift
//  
//
//  Created by Ziad Tamim on 03.11.21.
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

/// A label style that shows both the title and icon of the label using a
/// system-standard layout with spacing, and adding a bolded font.
public struct CalloutLabelStyle: LabelStyle {
  let spacing: CGFloat
  
  public func makeBody(configuration: Configuration) -> some View {
    Label {
      Spacer().frame(width: spacing)
      configuration.title
        .lineLimit(1)
        .font(.custom(.medium, relativeTo: .footnote))
        .truncationMode(.middle)
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

extension LabelStyle where Self == CalloutLabelStyle {
  
  /// A label style that shows both the title and icon of the label using a
  /// system-standard layout with spacing, and adding a bolded font.
  ///
  /// To apply this to a label:
  ///
  ///     Label("Lightning", systemImage: "bolt.fill")
  ///         .labelStyle(.calloutLabel(spacing: 20))
  ///
  /// - Parameter spacing: The distance between adjacent the title and icon.
  ///
  public static func calloutLabel(spacing: CGFloat) -> Self {
    CalloutLabelStyle(spacing: spacing)
  }
}
