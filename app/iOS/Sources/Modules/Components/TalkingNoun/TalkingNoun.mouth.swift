//
//  TalkingNoun.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit
import Services

extension TalkingNoun {
  
  final class Mouth: SKSpriteNode {
    
    private class var nounComposer: NounComposer {
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
