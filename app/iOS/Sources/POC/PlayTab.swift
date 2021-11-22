//
//  PlayTab.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-04.
//

import SwiftUI
import UIComponents
import Services
import SpriteKit

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
    let texture = SKTexture(imageNamed: shiftEyes.randomElement()!)
    texture.filteringMode = .nearest
    return texture
  }
  
  func startBlinkEyes() {
    let block = {
      let action = SKAction.sequence([
        SKAction.wait(forDuration: 1.0),
        SKAction.repeat(SKAction.animate(with: blinkEyes.compactMap {
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
    
    let seq = SKAction.sequence([SKAction.run(block), SKAction.wait(forDuration:4.0)])
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
        SKAction.repeat(SKAction.animate(with: blinkEyes.compactMap {
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

struct PlayTab: View {
  @State private var willMoveToNextScreen = false
  @Binding var isPresented: Bool
  
  var currentMouthSequence = [R.image.headApeMouth1.name]
  var currentEyeSequence = blinkEyes
  
  var scene: SKScene {
    let nounGameScene = NounGameScene(size: CGSize(width: 320, height: 320))
    nounGameScene.scaleMode = .fill
    return nounGameScene
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SpeechBubble("Give your noun something to say! Just speak and let your noun do the talking")
          .font(.custom(.regular, size: 15))
          .padding(.horizontal, 20)
          .padding(.vertical, 0)
        
        ZStack {
          SpriteView(scene: scene, options: [.allowsTransparency])
            .frame(width: 320, height: 320)
        }
          .padding(.top, -40)
          .padding(.bottom, 40)
        
        NavigationLink(isActive: $willMoveToNextScreen) {
          PlayRecord(isPresented: $willMoveToNextScreen)
        } label: {
          EmptyView()
        }
        
        OutlineButton(text: "Get Started",
                      icon: { Image.playOutline },
                      action: { willMoveToNextScreen.toggle() },
                      fill: [.width])
          .padding(.horizontal, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .softNavigationItems(leftAccessory: {
        SoftButton(
          icon: { Image.xmark },
          action: { isPresented.toggle() })
        
      }, rightAccessory: { EmptyView() })
      .background(Gradient.blueberryJam)
    }
  }
}

struct Play_Previews: PreviewProvider {
  static var previews: some View {
    PlayTab(isPresented: .constant(false))
  }
}
