//
//  SlideshowScene.swift
//  Nouns
//
//  Created by Krishna Satyanarayana on 2022-04-09.
//

import Foundation
import SpriteKit

/// A SpriteKit-based scene to animate a sequence of images loaded from a texture atlas.
final class SlideshowScene: SKScene {

  public init(images: [String], atlas: String, fps: CGFloat, repeats: Bool) {
    let screenSize = UIScreen.main.bounds.size
    super.init(size: screenSize)

    backgroundColor = .clear
    view?.allowsTransparency = true
    view?.backgroundColor = .clear

    let node = Node(images: images, atlas: atlas, fps: fps, repeats: repeats)
    node.size = screenSize
    node.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    addChild(node)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
