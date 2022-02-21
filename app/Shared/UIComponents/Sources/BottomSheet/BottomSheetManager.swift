//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-31.
//

import Combine
import SwiftUI

/**
 The Bottom Sheet Manager helps to handle the Bottom Sheet when you have many view layers.
 
 Make sure to pass an instance of this manager as an **environmentObject** to your root view in your Scene Delegate:
 ```
 let sheetManager: BottomSheetManager = BottomSheetManager()
 let window = UIWindow(windowScene: windowScene)
 window.rootViewController = UIHostingController(
 rootView: contentView.environmentObject(sheetManager)
 )
 ```
 */
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
  
  /**
   Presents a **Bottom Sheet**  with a dynamic height based on his content.
   - parameter content: The content to place inside of the Bottom Sheet.
   - parameter onDismiss: This code will be runned when the sheet is dismissed.
   */
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
  
  /**
   Updates some properties of the **Bottom Sheet**
   - parameter isPresented: If the bottom sheet is presented
   - parameter content: The content to place inside of the Bottom Sheet.
   - parameter onDismiss: This code will be runned when the sheet is dismissed.
   */
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
  /**
   Add a BottomSheet to the current view. You should attach it to your Root View.
   Use the BottomSheetManager as an environment object to present it whenever you want.
   - parameter style: The style configuration for the Bottom Sheet.
   */
  func addBottomSheet(
    style: BottomSheetStyle = BottomSheetStyle.defaultStyle()) -> some View {
      self.modifier(
        BottomSheet(style: style)
      )
    }
}
