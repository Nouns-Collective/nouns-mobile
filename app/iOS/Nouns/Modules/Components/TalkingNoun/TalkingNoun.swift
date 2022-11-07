// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

import Foundation
import SpriteKit
import NounsUI
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
    scaleMode = .aspectFill
    view?.showsFPS = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var head: Trait? = {
    let headAsset = nounComposer.heads[seed.head].assetImage
    // For the time being, we are not adding mouths on top of the head but instead just using the head itself as is
    // The heads without mouths are only needed for the play experience or whenever we want to animate the mouth
    let head = Trait(nounTraitName: headAsset)
    return head
  }()
  
  lazy var body: Trait? = {
    let bodyAsset = nounComposer.bodies[seed.body].assetImage
    let body = Trait(nounTraitName: bodyAsset)
    return body
  }()
  
  lazy var accessory: Trait? = {
    let accessoryAsset = nounComposer.accessories[seed.accessory].assetImage
    let accessory = Trait(nounTraitName: accessoryAsset)
    return accessory
  }()

  lazy var eyes = Eyes(seed: seed, frameSize: Self.traitSize)
  
  lazy var mouth = Mouth(seed: seed)
  
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
    guard mouth.parent == nil else { return }
    
    [body, accessory, head, eyes].compactMap { trait in
      trait?.position = CGPoint(x: frame.midX, y: frame.midY)
      trait?.size = Self.traitSize
      return trait
    }
    .forEach(addChild)
  }
}
