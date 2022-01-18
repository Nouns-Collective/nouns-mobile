//
//  TalkingNoun.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit

enum TalkingNounAnimationType: String {
  case talk
}

class TalkingNoun: SKSpriteNode {
  
  private lazy var eyes: Eyes = {
    let eyes = Eyes()
    eyes.position = CGPoint(x: frame.midX - 5, y: frame.midY + 4)
    eyes.size = CGSize(width: 320, height: 320)
    return eyes
  }()
  
  private lazy var talkTextures: [SKTexture] = {
    loadTextures(atlas: "head-ape-mouth", prefix: "head-ape-mouth_", from: 1, to: 5)
  }()
  
  init() {
    let texture = SKTexture(imageNamed: R.image.headApeMouth_1.name)
    texture.filteringMode = .nearest
    
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    setUpInitialState()
  }
  
  private func setUpInitialState() {
    addChild(eyes)
    
    eyes.startBlinking()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startTalking() {
    guard action(forKey: TalkingNounAnimationType.talk.rawValue) == nil else {
      return
    }
    
    let animation = SKAction.animate(
      with: talkTextures,
      timePerFrame: 0.05,
      resize: false,
      restore: true
    )
    
    let repeatAction = SKAction.repeatForever(animation)
    run(repeatAction, withKey: TalkingNounAnimationType.talk.rawValue)
  }
  
  func stopTalking() {
    removeAction(forKey: TalkingNounAnimationType.talk.rawValue)
  }
}
