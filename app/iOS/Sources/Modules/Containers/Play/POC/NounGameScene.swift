//
//  NounGameScene.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI
import UIComponents
import Services
import SpriteKit

let mouthSequence = [
  R.image.headApeMouth1.name,
  R.image.headApeMouth2.name,
  R.image.headApeMouth3.name,
  R.image.headApeMouth4.name,
]

let eyesBlinkSequence = [
  R.image.eyesBlink1.name,
  R.image.eyesBlink2.name,
  R.image.eyesBlink3.name,
  R.image.eyesBlink4.name,
]

let eyesShiftSequence = [
  R.image.eyesShift1.name,
  R.image.eyesShift2.name,
  R.image.eyesShift3.name,
  R.image.eyesShift4.name,
  R.image.eyesShift5.name,
  R.image.eyesShift6.name,
]

class NounGameScene: SKScene {
  
  override init(size: CGSize) {
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let nounSprite = SKSpriteNode(imageNamed: R.image.headApeMouth1.name)
  let eyeSprite = SKSpriteNode(imageNamed: R.image.eyesBlink1.name)
  
  let blinkEyesAnimationKey = "blinkEyesAnimation"
  var eyeBlinkAnimation: SKAction?
  
  override func didMove(to view: SKView) {
    backgroundColor = .clear
    view.allowsTransparency = true
    view.backgroundColor = .clear
    
    if nounSprite.parent == nil {
      nounSprite.texture?.filteringMode = .nearest
      nounSprite.size = CGSize(width: 320, height: 320)
      nounSprite.position = CGPoint(x: frame.midX, y: frame.midY)
      addChild(nounSprite)
    }
    
    if eyeSprite.parent == nil {
      eyeSprite.texture?.filteringMode = .nearest
      eyeSprite.size = CGSize(width: 320, height: 320)
      eyeSprite.position = CGPoint(x: frame.midX - 5, y: frame.midY + 3)
      addChild(eyeSprite)
    }
    
    startBlinkEyes()
  }
  
  deinit {
    stopBlinkEyes()
    stopMouthMoving()
    stopJustBlinkEyes()
    nounSprite.removeFromParent()
    eyeSprite.removeFromParent()
    removeFromParent()
  }
  
  func randomShiftEye() -> SKTexture {
    let texture = SKTexture(imageNamed: eyesShiftSequence.randomElement()!)
    texture.filteringMode = .nearest
    return texture
  }
  
  func startBlinkEyes() {
    let block = {
      let action = SKAction.sequence([
        SKAction.wait(forDuration: 1.0),
        SKAction.repeat(SKAction.animate(with: eyesBlinkSequence.compactMap {
          let textture = SKTexture(imageNamed: $0)
          textture.filteringMode = .nearest
          return textture
        }, timePerFrame: 0.1), count: 3),
        SKAction.wait(forDuration: 2.0),
        SKAction.setTexture(self.randomShiftEye()),
        SKAction.wait(forDuration: 2.0),
      ])
      
      self.eyeSprite.run(action)
    }
    
    let seq = SKAction.sequence([SKAction.run(block), SKAction.wait(forDuration: 4.0)])
    eyeBlinkAnimation = SKAction.repeatForever(seq)
    
    if eyeSprite.action(forKey: blinkEyesAnimationKey) == nil {
      eyeSprite.run(eyeBlinkAnimation!, withKey: blinkEyesAnimationKey)
    }
  }
  
  func stopBlinkEyes() {
    eyeSprite.removeAction(forKey: blinkEyesAnimationKey)
  }
  
  let justBlinkEyesAnimationKey = "justBlinkEyesAnimationKey"
  var justBlinkEyesAnimation: SKAction?
  
  func startJustBlinkEyes() {
    let block = {
      let action = SKAction.sequence([
        SKAction.wait(forDuration: 1.0),
        SKAction.repeat(SKAction.animate(with: eyesBlinkSequence.compactMap {
          let textture = SKTexture(imageNamed: $0)
          textture.filteringMode = .nearest
          return textture
        }, timePerFrame: 0.1), count: 3),
        SKAction.wait(forDuration: 2.0),
      ])
      
      self.eyeSprite.run(action)
    }
    
    let seq = SKAction.sequence([
      SKAction.run(block),
      SKAction.wait(forDuration: 4.0)
    ])
    justBlinkEyesAnimation = SKAction.repeatForever(seq)
    
    if eyeSprite.action(forKey: justBlinkEyesAnimationKey) == nil {
      eyeSprite.run(justBlinkEyesAnimation!, withKey: justBlinkEyesAnimationKey)
    }
  }
  
  func stopJustBlinkEyes() {
    eyeSprite.removeAction(forKey: justBlinkEyesAnimationKey)
  }
  
  let mouthMovingAnimationKey = "mouthMovingAnimationKey"
  var mouthMovingAnimation: SKAction?
  
  func startMouthMoving() {
    let block = {
      let action = SKAction.sequence([
        SKAction.animate(with: mouthSequence.compactMap {
          let textture = SKTexture(imageNamed: $0)
          textture.filteringMode = .nearest
          return textture
        }, timePerFrame: 0.1),
      ])
      self.nounSprite.run(action)
    }
    
    let seq = SKAction.sequence([
      SKAction.run(block),
      SKAction.wait(forDuration: 0.2)
    ])
    mouthMovingAnimation = SKAction.repeatForever(seq)
    
    if nounSprite.action(forKey: mouthMovingAnimationKey) == nil {
      mouthMovingAnimation?.speed = 2.0
      nounSprite.run(mouthMovingAnimation!, withKey: mouthMovingAnimationKey)
    }
  }
  
  func stopMouthMoving() {
    nounSprite.removeAction(forKey: mouthMovingAnimationKey)
    nounSprite.texture = SKTexture(imageNamed: mouthSequence.first!)
  }
}
