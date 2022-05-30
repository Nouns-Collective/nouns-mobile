//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-02.
//

import SwiftUI

public extension Image {
  
  /// Crops an image to fill the space while maintaining a center alignment
  func centerCropped() -> some View {
    GeometryReader { geo in
      self
        .resizable()
        .scaledToFill()
        .frame(width: geo.size.width, height: geo.size.height)
        .clipped()
    }
  }
}
