//
//  Eyes.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit

extension TalkingNoun {
  
  class Eyes: SKSpriteNode {
    
    /// Various eyes states.
    enum State: String {
      case idle
      case active
    }
    
    var state: State = .idle
    
    private lazy var blinkTextures: [SKTexture] = {
      loadTextures(atlas: "eyes-blink", prefix: "eyes-blink_", from: 1, to: 5)
    }()
    
    init() {
      let texture = SKTexture(imageNamed: R.image.eyesBlink_1.name)
      texture.filteringMode = .nearest
      
      super.init(texture: texture, color: SKColor.clear, size: texture.size())
      
      blink()
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    /// Default eyes
    /// (wait 500-2500ms)
    /// blink sequence
    /// (wait 500-2500ms)
    /// Default eyes (random left or right)
    /// …repeat
    private func blink() {
      guard action(forKey: State.idle.rawValue) == nil else {
        return
      }
      
      let pause = SKAction.wait(forDuration: 1.5, withRange: 2)
      let blink = SKAction.animate(with: blinkTextures, timePerFrame: 0.05)
      let goofyEye = SKAction.customAction(withDuration: 0.0, actionBlock: randomEye)
      let sequence = SKAction.sequence([blink, pause, goofyEye, pause])
      let repeatForever = SKAction.repeatForever(sequence)
      
      run(repeatForever, withKey: State.idle.rawValue)
    }
    
    private func randomEye(_ node: SKNode, _ elapsedTime: CGFloat) {
      let index = state == .active ? 0 : Int.random(in: 0...6)
      let texture = SKTexture(imageNamed: "eyes-shift_\(index)")
      texture.filteringMode = .nearest
      (node as? SKSpriteNode)?.texture = texture
    }
  }
}
