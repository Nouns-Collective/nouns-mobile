//
//  AlienEffect.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFAudio

struct AlienEffect: Effect {
  private(set) var rate = 1.0
  private(set) var audioUnits: [AVAudioUnit] = {
    let timePitchAU = AVAudioUnitTimePitch()
    timePitchAU.pitch = 100
    
    let distortionAU = AVAudioUnitDistortion()
    distortionAU.loadFactoryPreset(.speechCosmicInterference)
    distortionAU.wetDryMix = 100
    
    return [timePitchAU, distortionAU]
  }()
}
