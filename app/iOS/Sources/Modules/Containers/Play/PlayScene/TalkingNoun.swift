//
//  TalkingNoun.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import SpriteKit

class TalkingNoun: SKSpriteNode {
  
  enum State: String {
    case idle
    case lipSync
  }
  
  var state: State = .idle {
    didSet {
      handleStateChanges()
    }
  }
  
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
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func handleStateChanges() {
    switch state {
    case .idle:
      eyes.state = .idle
      idle()
    case .lipSync:
      eyes.state = .active
      lipSync()
    }
  }
  
  private func lipSync() {
    guard action(forKey: State.lipSync.rawValue) == nil else {
      return
    }
    
    let animation = SKAction.animate(
      with: talkTextures,
      timePerFrame: 0.07,
      resize: false,
      restore: true
    )
    
    let repeatAction = SKAction.repeatForever(animation)
    run(repeatAction, withKey: State.lipSync.rawValue)
  }
  
  private func idle() {
    removeAction(forKey: State.lipSync.rawValue)
  }
}
