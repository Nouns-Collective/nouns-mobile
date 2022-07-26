// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Krishna Satyanarayana
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

import Foundation
import SpriteKit

extension SlideshowScene {

  /// SpriteKit node that loads the texture atlas and animates through the sequence of images.
  final class Node: SKSpriteNode {

    /// Array of image assets to animate
    let images: [String]

    /// Name of the texture atlas from which to load the images.
    let atlas: String

    /// Number of frames per second that the animation runs at.
    let fps: CGFloat

    /// Boolean indicating whether the animation should loop.
    let repeats: Bool

    private lazy var textures: [SKTexture] = {
      loadTextures(atlas: atlas, images: images)
    }()

    init(images: [String], atlas: String, fps: CGFloat, repeats: Bool) {
      self.images = images
      self.atlas = atlas
      self.fps = fps
      self.repeats = repeats
      let texture = SKTexture(imageNamed: images.first ?? "")
      super.init(texture: texture, color: SKColor.clear, size: texture.size())
      if !images.isEmpty {
        startAnimation()
      }
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func startAnimation() {
      let animation = SKAction.animate(with: textures, timePerFrame: 1 / fps)
      if repeats {
        run(SKAction.repeatForever(animation))
      } else {
        run(animation)
      }
    }
  }
}
