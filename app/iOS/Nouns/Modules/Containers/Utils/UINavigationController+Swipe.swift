//
//  UINavigationController+Swipe.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-03-12.
//

import UIKit

/// This extension allows for swiping gestures to be used to go back, after using `NavigationLink` to
/// present a new view without the use of the iOS navigation bar or navigation bar back button
extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
