//
//  OnboardingView.CreateScene.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-04-29.
//

import SwiftUI
import UIComponents
import SpriteKit
import Services

extension OnboardingView {
  
  final class CreateScene: SKScene {
    
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
    }
    
    private func buildScene() {
      /// Adds a light, smaller secondary marquee in the background to create a "parallax" effect with the main larger foreground marquee text
      for i in 0...1 {
        let background = SKSpriteNode(imageNamed: "nouns-ios-03-marquee")
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
