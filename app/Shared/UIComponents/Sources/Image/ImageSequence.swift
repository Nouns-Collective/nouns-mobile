//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-02.
//

import SwiftUI

/// A view to display an animated sequence of images, like a flip book
public struct ImageSequence: View {
  
  @State private var image: Image = Image("")
  
  /// The images to use for the sequence
  private let images: [UIImage]
  
  /// The desired fps (frames per second) to animate the sequence at
  private let fps: CGFloat
  
  public init(images: [UIImage], fps: CGFloat = 30) {
    self.images = images
    self.fps = fps
  }
  
  public var body: some View {
    Group {
      image
        .centerCropped()
    }
    .onAppear {
      self.animate()
    }
  }
  
  private func animate() {
    var imageIndex: Int = 0
    
    Timer.scheduledTimer(withTimeInterval: 1 / fps, repeats: true) { _ in
      if imageIndex < self.images.count {
        self.image = Image(uiImage: self.images[imageIndex])
        imageIndex += 1
      } else {
        imageIndex = 0
      }
    }
  }
}
