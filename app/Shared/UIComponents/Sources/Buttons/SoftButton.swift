//
//  SoftButton.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

/// The button style configuration for the SoftButton
public struct SoftButtonStyle: ButtonStyle {
  @Environment (\.controlSize) var controlSize: ControlSize
  @Environment (\.isEnabled) var isEnabled: Bool
  
  /// The width of the button, determined by the controlSize environment property
  /// The two options are either an automatic width where it expands to fit it's contents (nil)
  /// or a width that takes up the width of the entire parent view
  private var width: CGFloat? {
    switch controlSize {
    case .large:
      return .infinity
    default:
      return nil
    }
  }
  
  /// Corner radius style of the button
  public let continuous: Bool
  
  public func makeBody(configuration: Self.Configuration) -> some View {
    configuration
      .label
      .frame(maxWidth: width)
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .foregroundColor(isEnabled ? Color.black : Color.black.opacity(0.4))
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.black.opacity(0.2), lineWidth: 6)
          .offset(x: 0, y: 2)
          .opacity(configuration.isPressed ? 1 : 0)
      }
      .background(Color.black.opacity(configuration.isPressed ? 0.1 : 0.05))
      .clipShape(RoundedRectangle(cornerRadius: continuous ? 10 : 6, style: continuous ? .continuous : .circular))
      .animation(.spring(), value: configuration.isPressed)
      .animation(.easeInOut, value: isEnabled)
  }
}

/// A label for buttons with text and an optional icon on the left of the text as well as an optional accessory image
public struct AccessoryButtonLabel<Accessory>: View where Accessory: View {
  @Environment (\.controlSize) var controlSize: ControlSize
  
  /// The optional icon to show on the left of the text
  let icon: Image?
  
  /// The icon for the button on the far right of the button (accessory image)
  let accessoryImage: Image?
  
  ///
  let accessory: Accessory
  
  /// The text for the button, appearing on the right side of the icon
  let text: String
  
  /// Boolean value to determine whether the button should be full width
  private var fullWidth: Bool {
    controlSize == .large
  }
  
  private var onlyText: Bool {
    icon == nil
  }
  
  public init(
    _ text: String,
    icon: Image?,
    accessoryImage: Image?
  ) where Accessory == EmptyView {
    self.text = text
    self.icon = icon
    self.accessoryImage = accessoryImage
    self.accessory = EmptyView()
  }
  
  public init(
    _ text: String,
    icon: Image?,
    accessory: Accessory,
    accessoryImage: Image? = nil
  ) {
    self.text = text
    self.icon = icon
    self.accessory = accessory
    self.accessoryImage = accessoryImage
  }
  
  public var body: some View {
    HStack(spacing: 10) {
      Label {
        Text(text)
          .font(Font.custom(.medium, size: 16))
      } icon: {
        icon?
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25, alignment: .center)
      }
      .labelStyle(.titleAndIcon(spacing: onlyText ? 0 : 12))
      
      if fullWidth {
        Spacer()
      }
      
      HStack {
        accessory
        
        if let accessory = accessoryImage {
          accessory
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 28, alignment: .center)
        }
      }
      .padding(.trailing, 6)
    }
    .padding(16)
  }
}

/// A label for buttons with text as well as an optional large accessory image
public struct LargeAccessoryButtonLabel<Accessory: View>: View {
  @Environment (\.controlSize) var controlSize: ControlSize
  @Environment (\.isEnabled) var isEnabled: Bool
  
  /// The accessory for the button on the far right of the button
  let accessory: Accessory?
  
  /// The text for the button, appearing on the right side of the icon
  let text: String
  
  /// Specify the tinting color for the content.
  let color: Color
  
  init(
    accessory: Accessory,
    text: String,
    color: Color
  ) {
    self.accessory = accessory
    self.text = text
    self.color = color
  }
  
  init(
    accessory: Accessory,
    text: String,
    color: Color
  ) where Accessory == Image {
    self.accessory = {
      accessory
        .resizable()
    }()
    self.text = text
    self.color = color
  }
  
  /// Boolean value to determine whether the button should be full width
  private var fullWidth: Bool {
    controlSize == .large
  }

  public var body: some View {
    HStack(spacing: 10) {
      Text(text)
        .font(Font.custom(.medium, relativeTo: .subheadline))
        .foregroundColor(isEnabled ? color : color.opacity(0.4))
      
      if fullWidth {
        Spacer()
      }
      
      if let accessory = accessory {
        accessory
          .aspectRatio(contentMode: .fit)
          .frame(height: 28, alignment: .center)
          .foregroundColor(color)
          .opacity(isEnabled ? 1 : 0.4)
      }
    }
    .padding(16)
    .animation(.easeInOut, value: isEnabled)
  }
}

public struct IconButtonLabel: View {
  
  /// The optional icon to show on the left of the text
  let icon: Image
  
  let padding: CGFloat
  
  public var body: some View {
    icon
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 16, height: 16, alignment: .center)
      .padding(padding)
  }
}

///
public struct SoftButton<Label: View>: View {
  
  /// The user-set label content for the button
  private let label: Label
  
  /// The action for the button once tapped
  private let action: () -> Void
  
  /// The corner radius style of the button
  private var continuous: Bool = false
  
  /// A computer property to determine if the button's corner curve should be continuous or circular
  private var isContinuous: Bool {
    Label.self == IconButtonLabel.self || continuous
  }
  
  /// Initializes a standard button with a custom view for the label and a designated action for when the button is tapped
  ///
  /// Using a custom label view.
  ///
  /// ```swift
  /// SoftButton(label: {
  ///     HStack {
  ///         Image(systemName: "arrow.clockwise")
  ///             .font(Font.body.weight(.medium))
  ///
  ///         Text("Black Button")
  ///             .font(Font.body.weight(.medium))
  ///     }.padding(.horizontal, 6)
  /// } action: {
  ///     print("Tapped")
  /// })
  /// ```
  ///
  /// - Parameters:
  ///   - continuous: The corner radius style of the button. If true, the button will have a greater
  ///   corner radius and a continuous corner curve
  ///   - label: A view for the label of the button
  ///   - action: The action function for when the button is tapped
  public init(
    continuous: Bool = false,
    @ViewBuilder label: () -> Label,
    action: @escaping () -> Void
  ) {
    self.continuous = continuous
    self.label = label()
    self.action = action
  }
  
  /// Initializes a soft button with an optional  icon, text, and optional accessory image to create a standard button, as well as a designated action
  ///
  /// Using a standard button label, with only text
  ///
  /// ```swift
  /// SoftButton(icon: {
  ///   Image(systemName: "hand.thumbsup.fill")
  /// }, text: "Get Started", smallAccessory: {
  ///     Image(systemName: "arrow.right")
  /// }, action: {})
  /// ```
  ///
  /// - Parameters:
  ///   - icon: The image for the button's icon (optional)
  ///   - text: The text for the button (optional)
  ///   - smallAccessory: The accessory image of the button
  ///   - action: The action function for when the button is tapped
  public init(
    text: String,
    @ViewBuilder icon: () -> Image? = { nil },
    @ViewBuilder smallAccessory: () -> Image? = { nil },
    action: @escaping () -> Void
  ) where Label == AccessoryButtonLabel<EmptyView> {
    self.label = {
      return AccessoryButtonLabel<EmptyView>(
        text,
        icon: icon(),
        accessoryImage: smallAccessory())
    }()
    
    self.action = action
  }
  
  /// Initializes a soft button with text, and an optional large accessory image to create a standard button, as well as a designated action
  ///
  /// Using a standard button label, with only text
  ///
  /// ```swift
  /// SoftButton(text: "Get Started", largeAccessory: {
  ///     Image(systemName: "arrow.right")
  /// }, action: {})
  /// ```
  ///
  /// - Parameters:
  ///   - text: The text for the button (optional)
  ///   - largeAccessory: The accessory image of the button
  ///   - color: The foreground color of the button content
  ///   - action: The action function for when the button is tapped
  public init<V>(
    text: String,
    @ViewBuilder largeAccessory: () -> V,
    color: Color = .black,
    action: @escaping () -> Void
  ) where Label == LargeAccessoryButtonLabel<V>, V: View {
    self.label = {
      return LargeAccessoryButtonLabel(
        accessory: largeAccessory(),
        text: text,
        color: color
      )
    }()
    
    self.action = action
  }
  
  /// Initializes a soft button with only an icon as it's label, as well as a designated action
  ///
  /// Using an icon button label, with only an icon
  ///
  /// ```swift
  /// SoftButton(icon: {
  ///     Image(systemName: "hand.thumbsup.fill")
  /// }, action: {})
  /// ```
  ///
  /// - Parameters:
  ///   - icon: The image for the button's icon
  ///   - action: The action function for when the button is tapped
  public init(
    @ViewBuilder icon: () -> Image,
    action: @escaping () -> Void
  ) where Label == IconButtonLabel {
    self.label = {
      return IconButtonLabel(icon: icon(), padding: 8)
    }()
    
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      label
    }
    .buttonStyle(SoftButtonStyle(continuous: continuous))
  }
}

struct SoftButton_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      SoftButton(icon: {
        Image(systemName: "hand.thumbsup.fill")
      }, action: {})
      
      SoftButton(text: "Get Started", largeAccessory: {
        Image(systemName: "arrow.right")
      }, action: {})
      
      SoftButton(text: "Get Started", icon: {
        Image(systemName: "hand.thumbsup.fill")
      }, smallAccessory: {
        Image(systemName: "arrow.right")
      }, action: {})
      
      SoftButton(label: {
        HStack {
          Image(systemName: "arrow.clockwise")
            .font(Font.body.weight(.medium))
          
          Text("Black Button")
            .font(Font.body.weight(.medium))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        
      }, action: {
        print("Tapped")
      })

      SoftButton(text: "Large accessory button disabled", largeAccessory: {
        Image(systemName: "hand.thumbsup.fill")
      }, action: {})
      .disabled(true)

      SoftButton(text: "Small accessory button disabled", smallAccessory: {
        Image(systemName: "hand.thumbsup.fill")
      }, action: {})
      .disabled(true)

      SoftButton(text: "Icon button disabled", icon: {
        Image(systemName: "hand.thumbsup.fill")
      }, action: {})
      .disabled(true)
    }
  }
}
