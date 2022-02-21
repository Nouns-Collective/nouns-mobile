//
//  TalkingNoun.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.02.22.
//

import Foundation
import SpriteKit
import UIComponents
import Services
import SwiftUI

final class TalkingNoun: SKScene {
  
  enum State: String {
    case idle
    case lipSync
  }
  
  /// A boolean to indicate if the noun is meaningful. Setting the value to true
  /// would animate the mouth up and down.
  var isTalking: Bool = false {
    didSet {
      isTalking ? mouth.lipSync() : mouth.idle()
      eyes.state = isTalking ? .active : .idle
    }
  }
  
  private var nounComposer: NounComposer {
    AppCore.shared.nounComposer
  }
  
  /// Indicates the size of the traits building the noun.
  static let traitSize = CGSize(width: 320, height: 320)
  
  ///
  private let seed: Seed
  
  init(seed: Seed) {
    self.seed = seed
    super.init(size: Self.traitSize)
    scaleMode = .fill
    view?.showsFPS = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var head: Trait? = {
    let headAsset = nounComposer.heads[seed.head].assetImage
    let traitAssetName = "heads-less-mouth/" + headAsset
    let head = Trait(nounTraitName: traitAssetName)
    return head
  }()
  
  private lazy var body: Trait? = {
    let bodyAsset = nounComposer.bodies[seed.body].assetImage
    let body = Trait(nounTraitName: bodyAsset)
    return body
  }()
  
  private lazy var accessory: Trait? = {
    let accessoryAsset = nounComposer.accessories[seed.accessory].assetImage
    let accessory = Trait(nounTraitName: accessoryAsset)
    return accessory
  }()
  
  private lazy var glasses = Trait(nounTraitName: "glasses-pink-empty")
  private lazy var eyes = Eyes()
  private lazy var mouth = Mouth(seed: seed)
  
  override func didMove(to view: SKView) {
    setUpInitialState()
  }
  
  private func setUpInitialState() {
    backgroundColor = .clear
    view?.allowsTransparency = true
    view?.backgroundColor = .clear
    
    [body, accessory, head, glasses, eyes].compactMap { trait in
      trait?.position = CGPoint(x: frame.midX, y: frame.midY)
      trait?.size = Self.traitSize
      return trait
    }
    .forEach(addChild)
    
    // Adding the same instance of talkingNoun multiple times results in a fatal error
    // This would happen when using `ScreenRecorder` to record this scene as
    // a `RecordingView` wrapper is created.
    if mouth.parent == nil {
      mouth.position = CGPoint(x: frame.midX, y: frame.midY)
      addChild(mouth)
    }
  }
}
