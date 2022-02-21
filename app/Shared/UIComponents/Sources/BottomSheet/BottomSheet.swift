//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-31.
//

import SwiftUI
import Combine

/// This is the modifier for the Bottom Sheet
public struct BottomSheet: ViewModifier {
  
  /// The Bottom Sheet Style configuration
  var style: BottomSheetStyle
  
  @EnvironmentObject private var manager: BottomSheetManager
  
  /// The rect containing the presenter
  @State private var presenterContentRect: CGRect = .zero
  
  /// The rect containing the sheet content
  @State private var sheetContentRect: CGRect = .zero
  
  /// The offset for keyboard height
  @State private var keyboardOffset: CGFloat = 0
  
  /// The offset for the drag gesture
  @State private var dragOffset: CGFloat = 0
  
  /// The point for the top anchor
  private var topAnchor: CGFloat {
    let topSafeArea = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
    let calculatedTop = presenterContentRect.height + topSafeArea - sheetContentRect.height
    
    guard calculatedTop < style.minTopDistance else {
      return calculatedTop
    }
    
    return style.minTopDistance
  }
  
  /// The he point for the bottom anchor
  private var bottomAnchor: CGFloat {
    return UIScreen.main.bounds.height + 5
  }
  
  /// Calculates the sheets y-position
  private var sheetPosition: CGFloat {
    if self.manager.isPresented {
      // 20.0 = To make sure we dont go under statusbar on screens without safe area inset
      let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20.0
      let position = self.topAnchor + self.dragOffset - self.keyboardOffset - 20
      
      if position < topInset {
        return topInset
      }
      
      return position
    } else {
      return self.bottomAnchor - self.dragOffset
    }
  }
  
  // MARK: - Content Builders
  
  public func body(content: Content) -> some View {
    ZStack {
      content
        .background(
          GeometryReader { proxy in
            // Add a tracking on the presenter frame
            Color.clear.preference(
              key: PresenterPreferenceKey.self,
              value: [PreferenceData(bounds: proxy.frame(in: .global))]
            )
          }
        )
        .onAppear {
          let notifier = NotificationCenter.default
          let willShow = UIResponder.keyboardWillShowNotification
          let willHide = UIResponder.keyboardWillHideNotification
          notifier.addObserver(forName: willShow,
                               object: nil,
                               queue: .main,
                               using: self.keyboardShow)
          notifier.addObserver(forName: willHide,
                               object: nil,
                               queue: .main,
                               using: self.keyboardHide)
        }
        .onDisappear {
          let notifier = NotificationCenter.default
          notifier.removeObserver(self)
        }
        .onPreferenceChange(PresenterPreferenceKey.self, perform: { (prefData) in
          DispatchQueue.main.async {
            self.presenterContentRect = prefData.first?.bounds ?? .zero
          }
        })
      
      sheetView()
        .edgesIgnoringSafeArea(.vertical)
    }
  }
}

public extension BottomSheet {
  
  private func sheetView() -> some View {
    
    // Build the drag gesture
    let drag = dragGesture()
    
    return ZStack {
      
      // The cover view
      if manager.isPresented {
        Group {
          if style.showDimmingView {
            Rectangle()
              .foregroundColor(BottomSheetStyle.dimmingViewColor)
          }
        }
        .edgesIgnoringSafeArea(.vertical)
        .onTapGesture {
          withAnimation(manager.defaultAnimation) {
            self.manager.isPresented = false
            self.dismissKeyboard()
            self.manager.onDismiss?()
          }
        }
      }
      
      // The sheet view
      Group {
        VStack(spacing: 0) {
          VStack {
            // Attach the SHEET CONTENT
            self.manager.content
              .background(
                GeometryReader { proxy in
                  Color.clear.preference(key: SheetPreferenceKey.self, value: [PreferenceData(bounds: proxy.frame(in: .global))])
                }
              )
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(Color.black, lineWidth: 4)
              )
              .background(Color.white)
              .cornerRadius(12)
              .padding()
          }
          
          Spacer()
        }
        .onPreferenceChange(SheetPreferenceKey.self, perform: { (prefData) in
          DispatchQueue.main.async {
            withAnimation(manager.defaultAnimation) {
              self.sheetContentRect = prefData.first?.bounds ?? .zero
            }
          }
        })
        .frame(width: UIScreen.main.bounds.width)
        .offset(y: self.sheetPosition)
        .gesture(drag)
        .animation(manager.defaultAnimation)
      }
    }
  }
}

// MARK: - Drag Gesture
extension BottomSheet {
  
  /// Creates a new drag gesture to manage dragging and dismissing the bottom sheet
  private func dragGesture() -> _EndedGesture<_ChangedGesture<DragGesture>> {
    DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
      .onChanged(onDragChanged)
      .onEnded(onDragEnded)
  }
  
  private func onDragChanged(drag: DragGesture.Value) {
    self.dismissKeyboard()
    let yOffset = drag.translation.height
    let threshold = CGFloat(-50)
    let stiffness = CGFloat(0.3)
    
    if yOffset > threshold {
      dragOffset = drag.translation.height
    } else if -yOffset + self.sheetContentRect.height < UIScreen.main.bounds.height {
      // if above threshold and belove ScreenHeight make it elastic
      let distance = yOffset - threshold
      let translationHeight = threshold + (distance * stiffness)
      dragOffset = translationHeight
    }
  }
  
  /// The method called when the drag ends. It moves the sheet in the correct position based on the last drag gesture
  private func onDragEnded(drag: DragGesture.Value) {
    /// The drag direction
    let verticalDirection = drag.predictedEndLocation.y - drag.location.y
    
    // Set the correct anchor point based on the vertical direction of the drag
    if verticalDirection > 1 {
      DispatchQueue.main.async {
        withAnimation(manager.defaultAnimation) {
          dragOffset = 0
          self.manager.isPresented = false
          self.manager.onDismiss?()
        }
      }
    } else if verticalDirection < 0 {
      withAnimation(manager.defaultAnimation) {
        dragOffset = 0
        self.manager.isPresented = true
      }
    } else {
      /// The current sheet position
      let cardTopEdgeLocation = topAnchor + drag.translation.height
      
      // Get the closest anchor point based on the current position of the sheet
      let closestPosition: CGFloat
      
      if (cardTopEdgeLocation - topAnchor) < (bottomAnchor - cardTopEdgeLocation) {
        closestPosition = topAnchor
      } else {
        closestPosition = bottomAnchor
      }
      
      withAnimation(manager.defaultAnimation) {
        dragOffset = 0
        self.manager.isPresented = (closestPosition == topAnchor)
        if !manager.isPresented {
          manager.onDismiss?()
        }
      }
    }
  }
}

// MARK: - Keyboard Handlers Methods
public extension BottomSheet {
  
  /// Add the keyboard offset
  private func keyboardShow(notification: Notification) {
    withAnimation(manager.defaultAnimation) {
      self.keyboardOffset = 20
    }
  }
  
  /// Remove the keyboard offset
  private func keyboardHide(notification: Notification) {
    DispatchQueue.main.async {
      withAnimation(manager.defaultAnimation) {
        self.keyboardOffset = 0
      }
    }
  }
  
  /// Dismiss the keyboard
  private func dismissKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    DispatchQueue.main.async {
      UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
  }
}

// MARK: - PreferenceKeys Handlers
public extension BottomSheet {
  
  /// Preference Key for the Sheet Presener
  struct PresenterPreferenceKey: PreferenceKey {
    public static func reduce(value: inout [BottomSheet.PreferenceData], nextValue: () -> [BottomSheet.PreferenceData]) {
      value.append(contentsOf: nextValue())
    }
    public static var defaultValue: [PreferenceData] = []
  }
  
  /// Preference Key for the Sheet Content
  struct SheetPreferenceKey: PreferenceKey {
    public static func reduce(value: inout [BottomSheet.PreferenceData], nextValue: () -> [BottomSheet.PreferenceData]) {
      value.append(contentsOf: nextValue())
    }
    public static var defaultValue: [PreferenceData] = []
  }
  
  /// Data Stored in the Preferences
  struct PreferenceData: Equatable {
    let bounds: CGRect
  }
  
}

public struct BottomSheetAddView<Base: View, InnerContent: View>: View {
  
  @EnvironmentObject var bottomSheetManager: BottomSheetManager
  
  @Binding var isPresented: Bool
  let content: () -> InnerContent
  let base: Base
  
  public var body: some View {
    base
      .onChange(of: isPresented, perform: { _ in updateContent() })
  }
  
  func updateContent() {
    bottomSheetManager.updateBottomSheet(isPresented: isPresented, content: content, onDismiss: {
      self.isPresented = false
    })
  }
}

public extension View {
  
  /// Presents a bottom sheet to the nearest view that utilizes the `.addBottomSheet()` view modifier
  func bottomSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
    BottomSheetAddView(isPresented: isPresented, content: content, base: self)
  }
}
