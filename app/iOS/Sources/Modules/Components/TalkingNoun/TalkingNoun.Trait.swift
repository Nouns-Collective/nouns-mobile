//
//  TalkingNoun.Body.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.02.22.
//

import Foundation
import SpriteKit

extension TalkingNoun {
  
  final class Trait: SKSpriteNode {
    
    init?(nounTraitName: String) {
      guard let image = UIImage(nounTraitName: nounTraitName) else {
        return nil
      }
      
      let texture = SKTexture(image: image)
      texture.filteringMode = .nearest
      
      super.init(texture: texture, color: SKColor.clear,
                 size: TalkingNoun.traitSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
