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
    
    enum State: String {
      case idle
      case lipSync
    }
    
    var state: State = .idle {
      didSet {
        handleStateChanges()
      }
    }
    
    private class var nounComposer: NounComposer {
      AppCore.shared.nounComposer
    }
    
    private lazy var eyes: TalkingNoun.Eyes = {
      let eyes = Eyes()
      eyes.position = CGPoint(x: frame.midX, y: frame.midY)
      eyes.size = CGSize(width: 320, height: 320)
      return eyes
    }()
    
    private let mouthTextures: [SKTexture]
    
    init(seed: Seed) {
      guard let mouthTextures = Self.nounComposer.heads[seed.head].textures["mouth"] else {
        fatalError("Couldn't load mouth textures.")
      }
      
      self.mouthTextures = Self.loadTextures(atlases: mouthTextures)
      
      guard let mouth = mouthTextures.first else {
        fatalError("Mouth texture not found.")
      }
      
      let texture = SKTexture(imageNamed: mouth)
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
        with: mouthTextures,
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
}
