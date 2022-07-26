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
      // Adds a light, smaller secondary marquee in the background to
      // create a "parallax" effect with the main larger foreground marquee text
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
