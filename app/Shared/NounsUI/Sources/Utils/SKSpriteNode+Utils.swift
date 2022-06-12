// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

extension SKSpriteNode {
  
  /// Load texture arrays for animations.
  public func loadTextures(atlas: String, prefix: String, from: Int, to: Int) -> [SKTexture] {
    let textureAtlas = SKTextureAtlas(named: atlas)
    return (from...to).reduce([]) {
      let texture = textureAtlas.textureNamed("\(prefix)\($1)")
      texture.filteringMode = .nearest
      return $0 + [texture]
    }
  }

  /// Load texture atlas given an array of image names
  public func loadTextures(atlas: String, images: [String]) -> [SKTexture] {
    let textureAtlas = SKTextureAtlas(named: atlas)
    return images.reduce([]) {
      let texture = textureAtlas.textureNamed($1)
      texture.filteringMode = .nearest
      return $0 + [texture]
    }
  }
  
  public static func loadTextures(atlases: [String]) -> [SKTexture] {
    guard var atlas = atlases.first?.components(separatedBy: "-") else {
      return []
    }
    
    atlas.removeLast()
    
    let textureAtlas = SKTextureAtlas(named: atlas.joined(separator: "-"))
    return atlases.reduce([]) {
      let texture = textureAtlas.textureNamed($1)
      texture.filteringMode = .nearest
      return $0 + [texture]
    }
  }
}
