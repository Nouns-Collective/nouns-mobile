//
//  JigsawEffect.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFAudio

struct JigsawEffect: Effect {
  private(set) var rate = 1.0
  private(set) var audioUnits: [AVAudioUnit] = {
    let distortionAU = AVAudioUnitDistortion()
    distortionAU.loadFactoryPreset(.speechWaves)
    distortionAU.wetDryMix = 20
    
    let timePitchAU = AVAudioUnitTimePitch()
    timePitchAU.pitch = -300
    
    return [distortionAU, timePitchAU]
  }()
}
