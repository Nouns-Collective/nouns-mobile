//
//  Effect.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFAudio

protocol Effect {
    var rate: Double { get }
    var audioUnits: [AVAudioUnit] { get }
}
