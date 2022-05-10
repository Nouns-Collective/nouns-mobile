//
//  OnboardingView.ExploreScene.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-04-29.
//

import SwiftUI
import UIComponents
import SpriteKit

extension OnboardingView {
  
  final class ExploreScene: SKScene, ObservableObject {
    
    static let horizontalPadding: CGFloat = 50
    
    static let cardVerticalPadding: CGFloat = 95
    
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
      for i in 0...1 {
        let cards = SKSpriteNode(imageNamed: "nouns-onboarding-02-cards")
        cards.anchorPoint = .zero
        
        cards.aspectFillToSize(fillSize: CGSize(width: size.width - ExploreScene.horizontalPadding, height: size.height))
        cards.position = CGPoint(x: ExploreScene.horizontalPadding / 2, y: (cards.size.height * CGFloat(i)) - (ExploreScene.cardVerticalPadding * CGFloat(i)) - 150) // The 150 is an offset to ensure the card animations starts in the middle of the screen.
        addChild(cards)
        
        let moveDown = SKAction.moveBy(x: 0, y: -cards.size.height, duration: 20)
        let moveReset = SKAction.moveBy(x: 0, y: cards.size.height - ExploreScene.cardVerticalPadding, duration: 0)
        let moveLoop = SKAction.sequence([moveDown, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        cards.run(moveForever)
      }
    }
  }
}
