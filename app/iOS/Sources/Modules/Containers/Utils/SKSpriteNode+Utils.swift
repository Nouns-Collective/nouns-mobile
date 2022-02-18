//
//  SKSpriteNode+Utils.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
  
  /// Load texture arrays for animations.
  func loadTextures(atlas: String, prefix: String, from: Int, to: Int) -> [SKTexture] {
    let textureAtlas = SKTextureAtlas(named: atlas)
    return (from...to).reduce([]) {
      let texture = textureAtlas.textureNamed("\(prefix)\($1)")
      texture.filteringMode = .nearest
      return $0 + [texture]
    }
  }
  
  static func loadTextures(atlases: [String]) -> [SKTexture] {
    guard let atlas = atlases.first else { return [] }
    
    let textureAtlas = SKTextureAtlas(named: atlas)
    return atlases.reduce([]) {
      let texture = textureAtlas.textureNamed($1)
      texture.filteringMode = .nearest
      return $0 + [texture]
    }
  }
}
