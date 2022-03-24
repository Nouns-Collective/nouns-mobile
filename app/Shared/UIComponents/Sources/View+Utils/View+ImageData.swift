//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-17.
//

import SwiftUI

public extension View {
  
  /// Converts a SwiftUI view into image data
  func asImageData() -> Data {
    let controller = UIHostingController(rootView: edgesIgnoringSafeArea(.all))
    let view = controller.view
    
    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    
    return renderer.jpegData(withCompressionQuality: 1.0, actions: { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    })
  }
}