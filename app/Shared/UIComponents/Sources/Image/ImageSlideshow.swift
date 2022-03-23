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
  
  /// The desired fps (frames per second) to animate the sequence at
  private let fps: CGFloat
  
  private let repeats: Bool
  
  @State private var imageIndex: Int = 0
    
  public init(images: [String], fps: CGFloat = 30, repeats: Bool = true) {
    self.images = images
    self.fps = fps
    self.repeats = repeats
  }
  
  public var body: some View {
    TimelineView(.periodic(from: .now, by: 1 / fps)) { context in
      SlideshowImageView(now: context.date, images: images, repeats: repeats)
    }
  }
}

internal struct SlideshowImageView: View {
  
  public let now: Date
  
  public let images: [String]
    
  public let repeats: Bool

  @State private var index: Int = 0
  
  var body: some View {
    Group {
      if !images.isEmpty, let image = UIImage(named: images[index % images.count]) {
        Image(uiImage: image)
          .centerCropped()
      }
    }.onChange(of: now) { _ in
      if index < images.count || repeats {
       index += 1
      }
    }
  }
}
