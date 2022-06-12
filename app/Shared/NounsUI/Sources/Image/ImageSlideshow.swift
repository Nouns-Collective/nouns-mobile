// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import Combine
import SpriteKit

/// A view to display an animated sequence of images, like a flip book
public struct ImageSlideshow: View {
  
  @State private var image: Image = Image("")
  
  /// The names of the images to use for the sequence
  private let images: [String]
  
  /// The desired fps (frames per second) to animate the sequence at
  private let fps: CGFloat
  
  private let repeats: Bool

  private let scene: SKScene?
  
  @State private var imageIndex: Int = 0
    
  public init(images: [String], atlas: String? = nil, fps: CGFloat = 30, repeats: Bool = true) {
    self.images = images
    self.fps = fps
    self.repeats = repeats
    if let atlas = atlas {
      self.scene = SlideshowScene(images: images, atlas: atlas, fps: fps, repeats: repeats)
    } else {
      self.scene = nil
    }
  }
  
  public var body: some View {
    if let scene = scene {
      SpriteView(scene: scene, options: [.allowsTransparency])
    } else {
      TimelineView(.periodic(from: .now, by: 1 / fps)) { context in
        SlideshowImageView(now: context.date, images: images, repeats: repeats)
      }
      .drawingGroup()
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
