//
//  TalkingNoun.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.02.22.
//

import Foundation
import SpriteKit
import Combine

final class TalkingNoun: SKScene {
  
  /// A boolean to indicate if the noun is meaningful. Setting the value to true
  /// would animate the mouth up and down.
  var isTalking: Bool = false {
    didSet {
      mouth.state = isTalking ? .lipSync : .idle
    }
  }
  
  /// Indicates the size of the traits building the noun.
  private let traitSize = CGSize(width: 320, height: 320)
  
  override init() {
    super.init(size: traitSize)
    scaleMode = .fill
    view?.showsFPS = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var mouth: Mouth = {
    let mouth = Mouth()
    mouth.position = CGPoint(x: frame.midX, y: frame.midY)
    mouth.size = traitSize
    return mouth
  }()
  
  override func didMove(to view: SKView) {
    setUpInitialState()
  }
  
  private func setUpInitialState() {
    backgroundColor = .clear
    view?.allowsTransparency = true
    view?.backgroundColor = .clear
    
    // Adding the same instance of talkingNoun multiple times results in a fatal error
    // This would happen when using `ScreenRecorder` to record this scene as
    // a `RecordingView` wrapper is created.
    if mouth.parent == nil {
      addChild(mouth)
    }
  }
}
