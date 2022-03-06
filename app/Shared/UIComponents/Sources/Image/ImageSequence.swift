//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-02.
//

import SwiftUI
import Combine

/// A view to display an animated sequence of images, like a flip book
public struct ImageSequence: View {
  
  @State private var image: Image = Image("")
  
  /// The names of the images to use for the sequence
  private let images: [String]
  
  /// The desired fps (frames per second) to animate the sequence at
  private let fps: CGFloat
  
  @State private var imageIndex: Int = 0
    
  public init(images: [String], fps: CGFloat = 30) {
    self.images = images
    self.fps = fps
  }
  
  public var body: some View {
    TimelineView(.periodic(from: .now, by: 1 / fps)) { context in
      if let image = UIImage(named: images[imageIndex % images.count]) {
        Image(uiImage: image)
          .centerCropped()
          .onChange(of: context.date) { (_: Date) in
            imageIndex += 1
          }
      }
    }
  }
}
