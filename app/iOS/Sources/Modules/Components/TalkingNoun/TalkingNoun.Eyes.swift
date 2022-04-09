//
//  Eyes.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit

extension TalkingNoun {
  
  final class Eyes: SKSpriteNode {
    
    /// Various eyes states.
    enum State: String {
      case idle
      case active
    }
    
    var state: State = .idle
    let eyesNode = SKSpriteNode()
    
    private lazy var blinkTextures: [SKTexture] = {
      loadTextures(atlas: "eyes-blink", prefix: "eyes-blink_", from: 1, to: 5)
    }()
    
    init(frameSize: CGSize) {
      let glassesFrameTexture = SKTexture(imageNamed: R.image.glassesFramesSquareBlack.name)
      glassesFrameTexture.filteringMode = .nearest
      super.init(texture: glassesFrameTexture, color: SKColor.clear, size: frameSize)

      eyesNode.texture = SKTexture(imageNamed: R.image.eyesBlink_1.name)
      eyesNode.size = frameSize
      addChild(eyesNode)
      
      animateEyes()
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    /// Default eyes
    /// (wait 1000-3000ms)
    /// blink sequence
    /// (wait 1000-3000ms)
    /// eyes looking around
    /// …repeat
    private func animateEyes() {
      guard action(forKey: State.idle.rawValue) == nil else {
        return
      }
      
      let pause = SKAction.wait(forDuration: 2, withRange: 2)
      let blink = SKAction.run {
        self.eyesNode.run(SKAction.animate(with: self.blinkTextures, timePerFrame: 0.05))
      }
      let goofyEye = SKAction.customAction(withDuration: 0.0, actionBlock: randomEye)
      let sequence = SKAction.sequence([blink, pause, goofyEye, pause])
      let repeatForever = SKAction.repeatForever(sequence)
      
      run(repeatForever, withKey: State.idle.rawValue)
    }
    
    private func randomEye(_ node: SKNode, _ elapsedTime: CGFloat) {
      let index = state == .active ? 0 : Int.random(in: 0...6)
      let texture = SKTexture(imageNamed: "eyes-shift_\(index)")
      texture.filteringMode = .nearest
      eyesNode.texture = texture
    }
  }
}
