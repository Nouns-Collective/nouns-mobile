// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI
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
