//
//  Eyes.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit

extension TalkingNoun {
  
  enum EyesBlinkAnimation: String {
    case normal
  }

  class Eyes: SKSpriteNode {
    
    private lazy var blinkTextures: [SKTexture] = {
      loadTextures(atlas: "eyes-blink", prefix: "eyes-blink_", from: 1, to: 5)
    }()
    
    private var blinkTimeInterval: CGFloat = 1.0
    
    init() {
      let texture = SKTexture(imageNamed: R.image.eyesBlink_1.name)
      texture.filteringMode = .nearest
      
      super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func startBlinking() {
      guard action(forKey: EyesBlinkAnimation.normal.rawValue) == nil else {
        return
      }
      
      let blink = SKAction.animate(
        with: blinkTextures,
        timePerFrame: 0.05,
        resize: false,
        restore: true
      )
      
      let wait = SKAction.wait(forDuration: 1.5, withRange: 2)
      let goofyEye = SKAction.animate(with: [randomEye()], timePerFrame: 0.0)
      let sequence = SKAction.sequence([blink, wait])
      
      let repeatForever = SKAction.repeatForever(sequence)
      
      run(repeatForever, withKey: EyesBlinkAnimation.normal.rawValue)
    }
    
    private func randomEye() -> SKTexture {
      let index = Int.random(in: 1...6)
      let texture = SKTexture(imageNamed: "eyes-shift_\(index)")
      texture.filteringMode = .nearest
      return texture
    }
  }
}
