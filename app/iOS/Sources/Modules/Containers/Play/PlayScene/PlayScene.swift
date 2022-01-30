//
//  NounPlayScene.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import SpriteKit
import SwiftUI
import Combine

extension NounPlayground {
  
  class PlayScene: SKScene {
    
    @ObservedObject var viewModel: ViewModel
    
    var audioProcessingStateSink: AnyCancellable?
    
    init(viewModel: ViewModel, size: CGSize) {
      self._viewModel = ObservedObject(wrappedValue: viewModel)
      super.init(size: size)
      
      audioProcessingStateSink = viewModel.voiceChangerEngine.$audioProcessingState
        .sink { status in
          switch status {
          case .loud:
            self.talkingNoun.state = .lipSync
          case .silent, .undefined:
            self.talkingNoun.state = .idle
          }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var talkingNoun: TalkingNoun = {
      let noun = TalkingNoun()
      noun.position = CGPoint(x: frame.midX, y: frame.midY)
      noun.size = CGSize(width: 320, height: 320)
      return noun
    }()
    
    override func didMove(to view: SKView) {
      setUpInitialState()
    }
    
    private func setUpInitialState() {
      backgroundColor = .clear
      view?.allowsTransparency = true
      view?.backgroundColor = .clear
      
      if talkingNoun.parent == nil {
        addChild(talkingNoun)
      }
    }
  }
}
