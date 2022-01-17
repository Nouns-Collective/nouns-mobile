//
//  NounPlayScene.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import SpriteKit

extension NounPlayground {
  
  class PlayScene: SKScene {
    
    private lazy var talkingNoun: TalkingNoun = {
      let noun = TalkingNoun()
      noun.position = CGPoint(x: frame.midX, y: frame.midY)
      noun.size = CGSize(width: 320, height: 320)
      return noun
    }()
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel, size: CGSize) {
      self.viewModel = viewModel
      super.init(size: size)
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
      
      addChild(talkingNoun)
    }
  }
}
