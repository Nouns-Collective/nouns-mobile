//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-31.
//

import Combine
import SwiftUI

/// An observable obejct that helps the app handle the bottom sheet when you have many view layers.
/// Make sure to pass an instance of this manager as an **environmentObject** to your root view in the SwiftUI `App`
public class BottomSheetManager: ObservableObject {
  
  /// Published var to present or hide the bottom sheet
  @Published var isPresented: Bool = false {
    didSet {
      if !isPresented {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
          self?.content = AnyView(EmptyView())
          self?.onDismiss = nil
        }
      }
    }
  }
  /// The content of the sheet
  @Published private(set) var content: AnyView
  /// the onDismiss code runned when the bottom sheet is closed
  private(set) var onDismiss: (() -> Void)?
  
  /// Possibility to customize the slide in/out animation of the bottom sheet
  public var defaultAnimation: Animation = .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
  
  public init() {
    self.content = AnyView(EmptyView())
  }
  
  
  /// Presents a bottom sheet  with a dynamic height based on his content.
  ///
  /// - Parameters:
  ///   - content: The content to place inside of the bottom sheet
  ///   - onDismiss: This code will be runned when the sheet is dismissed.
  public func showBottomSheet<T>(_ onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> T) where T: View {
    guard !isPresented else {
      withAnimation(defaultAnimation) {
        updateBottomSheet(
          content: {
            // do not animate the content, just the bottom sheet
            withAnimation(nil) {
              content()
            }
          },
          onDismiss: onDismiss)
      }
      return
    }
    
    self.content = AnyView(content())
    self.onDismiss = onDismiss
    DispatchQueue.main.async {
      withAnimation(self.defaultAnimation) {
        self.isPresented = true
      }
    }
  }
  
  
  /// Updates some properties of the bottom sheet
  ///
  /// - Parameters:
  ///   - isPresented: If the bottom sheet is presented
  ///   - content: The content to place inside of the Bottom Sheet.
  ///   - onDismiss: This code will be runned when the sheet is dismissed.
  public func updateBottomSheet<T>(isPresented: Bool? = nil, content: (() -> T)? = nil, onDismiss: (() -> Void)? = nil) where T: View {
    if let content = content {
      self.content = AnyView(content())
    }
    if let onDismiss = onDismiss {
      self.onDismiss = onDismiss
    }
    if let isPresented = isPresented {
      withAnimation(defaultAnimation) {
        self.isPresented = isPresented
      }
    }
  }
  
  /// Close the Bottom Sheet and run the onDismiss function if it has been previously specified
  public func closeBottomSheet() {
    withAnimation(defaultAnimation) {
      self.isPresented = false
    }
    self.onDismiss?()
  }
}

public extension View {
  
  /// Add a BottomSheet to the current view, whereby any child of this view (in the same navigation stack, not full screen covers),
  /// can use the `BottomSheetManager` or `.bottomSheet` view modifier to present a bottom sheet from that root view.
  /// This ensures that wherever the `.bottomSheet` view modifier is used, the bottom sheet itself is presented over (highest z-index)
  /// all the content of the root view where `.addBottomSheet` is used.
  ///
  /// - Parameters:
  ///   - style: The style configuration for the Bottom Sheet.
  func addBottomSheet(
    style: BottomSheetStyle = BottomSheetStyle.defaultStyle()) -> some View {
      self.modifier(
        BottomSheet(style: style)
      )
    }
}
