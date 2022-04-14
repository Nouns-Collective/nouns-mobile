//
//  SlideshowScene.Node.swift
//  
//
//  Created by Krishna Satyanarayana on 2022-04-10.
//

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
