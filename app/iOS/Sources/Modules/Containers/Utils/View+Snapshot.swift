//
//  View+Snapshot.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-15.
//

import SwiftUI

extension View {
  func asImage() -> UIImage {
    let controller = UIHostingController(rootView: self)
    let view = controller.view
    
    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    
    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}
