//
//  IntroductionOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-04-29.
//

import SwiftUI
import NounsUI
import SpriteKit
import Services

extension OnboardingView {
  
  final class IntroScene: SKScene, ObservableObject {
    
    /// Indicates the size of the traits building the noun.
    private var traitSize: CGSize { CGSize(width: size.width, height: size.width) }
    
    /// Shark noun
    private let seed: Seed = .init(background: 0, glasses: 3, head: 187, body: 4, accessory: 7)
    
    private var nounComposer: NounComposer {
      AppCore.shared.nounComposer
    }
    
    private lazy var body: TalkingNoun.Trait? = {
      let bodyAsset = nounComposer.bodies[seed.body].assetImage
      let body = TalkingNoun.Trait(nounTraitName: bodyAsset)
      return body
    }()
    
    private lazy var head: TalkingNoun.Trait? = {
      let headAsset = nounComposer.heads[seed.head].assetImage
      let head = TalkingNoun.Trait(nounTraitName: headAsset)
      return head
    }()
    
    private lazy var accessory: TalkingNoun.Trait? = {
      let accessoryAsset = nounComposer.accessories[seed.accessory].assetImage
      let accessory = TalkingNoun.Trait(nounTraitName: accessoryAsset)
      return accessory
    }()
    
    private lazy var eyes = TalkingNoun.Eyes(seed: seed, frameSize: traitSize, blinkOnly: false)
    
    private lazy var traitGroupNode: SKSpriteNode = {
      let group = SKSpriteNode()
      group.size = traitSize
      group.position = CGPoint(x: frame.midX, y: traitSize.height / 2)
      
      [body, accessory, head, eyes].compactMap { trait in
        trait?.size = traitSize
        return trait
      }
      .forEach(group.addChild)
      
      return group
    }()
    
    override init(size: CGSize) {
      super.init(size: size)
      scaleMode = .fill
      view?.showsFPS = false
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
      setUpInitialState()
    }
    
    private func setUpInitialState() {
      backgroundColor = .clear
      view?.allowsTransparency = true
      view?.backgroundColor = .clear
      
      buildScene()
      
      addChild(traitGroupNode)
    }
    
    private func buildScene() {
      /// Adds a light, smaller secondary marquee in the background to create a "parallax" effect with the main larger foreground marquee text
      for i in 0...1 {
        let background = SKSpriteNode(imageNamed: "nouns-ios-01-marquee")
        background.anchorPoint = .zero
        background.position = CGPoint(x: (size.width * CGFloat(i)) - CGFloat(1 * i), y: 0)
        background.size = size
        addChild(background)
        
        let moveLeft = SKAction.moveBy(x: -size.width, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x: size.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        background.run(moveForever)
      }
    }
  }
}

extension SKSpriteNode {
  
  func aspectFillToSize(fillSize: CGSize) {
    guard let texture = texture else {
      return
    }
    
    self.size = texture.size()
    
    let verticalRatio = fillSize.height / texture.size().height
    let horizontalRatio = fillSize.width / texture.size().width
    
    let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
    self.setScale(scaleRatio)
  }
}
