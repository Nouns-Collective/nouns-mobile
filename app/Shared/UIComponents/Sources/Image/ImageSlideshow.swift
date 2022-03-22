//
//  ImageSlideshow.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-02.
//

import SwiftUI
import Combine

/// A view to display an animated sequence of images, like a flip book
public struct ImageSlideshow: View {
  
  @State private var image: Image = Image("")
  
  /// The names of the images to use for the sequence
  private let images: [String]
  
  /// The bundle where the specified images can be found
  private let bundle: Bundle

  /// The desired fps (frames per second) to animate the sequence at
  private let fps: CGFloat
  
  @State private var imageIndex: Int = 0
    
  public init(images: [String], bundle: Bundle = Bundle.main, fps: CGFloat = 30) {
    self.images = images
    self.bundle = bundle
    self.fps = fps
  }
  
  public var body: some View {
    TimelineView(.periodic(from: .now, by: 1 / fps)) { context in
      SlideshowImageView(now: context.date, images: images, bundle: bundle)
    }
  }
}

internal struct SlideshowImageView: View {
  
  public let now: Date
  
  public let images: [String]
  
  public let bundle: Bundle

  @State private var index: Int = 0
  
  var body: some View {
    Group {
      if let image = UIImage(named: images[index % images.count], in: bundle, with: nil) {
        Image(uiImage: image)
          .centerCropped()
      }
    }.onChange(of: now) { _ in
      index += 1
    }
  }
}
