//
//  ChipmunkEffect.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFAudio

struct ChipmunkEffect: Effect {
  private(set) var rate = 1.0
  private(set) var audioUnits: [AVAudioUnit] = {
    let timePitchAU = AVAudioUnitTimePitch()
    timePitchAU.pitch = 1300
    
    return [timePitchAU]
  }()
}
