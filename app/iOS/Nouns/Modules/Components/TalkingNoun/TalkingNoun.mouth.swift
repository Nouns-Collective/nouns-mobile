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
import Services

extension TalkingNoun {
  
  final class Mouth: SKSpriteNode {
    
    private static var nounComposer: NounComposer {
      AppCore.shared.nounComposer
    }
    
    private let mouthTextures: [SKTexture]
    
    init(seed: Seed) {
      guard let mouthAssets = Self.nounComposer.heads[seed.head].textures["mouth"] else {
        fatalError("Couldn't load mouth textures.")
      }
      
      mouthTextures = Self.loadTextures(atlases: mouthAssets)
      
      super.init(texture: mouthTextures.first,
                 color: SKColor.clear,
                 size: TalkingNoun.traitSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func lipSync() {
      // Skip if the animation is already playing.
      guard action(forKey: State.lipSync.rawValue) == nil else {
        return
      }
      
      let animation = SKAction.animate(
        with: mouthTextures,
        timePerFrame: 0.07,
        resize: false,
        restore: true
      )
      
      let repeatAction = SKAction.repeatForever(animation)
      run(repeatAction, withKey: State.lipSync.rawValue)
    }
    
    func idle() {
      removeAction(forKey: State.lipSync.rawValue)
    }
  }
}
