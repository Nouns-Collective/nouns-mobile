//
//  Effect+AudioUnits.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation

extension VoiceChangerEngine.Effect {
  
  var unit: Effect {
    switch self {
    case .alien:
      return AlienEffect()
      
    case .monster:
      return JigsawEffect()
      
    case .chipmunk:
      return ChipmunkEffect()
      
    case .robot:
      return DarthVaderEffect()
    }
  }
}
