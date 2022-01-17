//
//  PowerMeter.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import AVFoundation

/// Calculates audio powers.
class PowerMeter {
  
  enum Status {
    case sound
    case silence
  }
  
  func process(buffer: AVAudioPCMBuffer) -> Status {
    guard let channelData = buffer.floatChannelData else {
      return .silence
    }
    
    let channelDataValue = channelData.pointee
    let channelDataValueArray = stride(
      from: 0,
      to: Int(buffer.frameLength),
      by: buffer.stride)
      .map { channelDataValue[$0] }
    
    let rms = sqrt(channelDataValueArray.map {
      return $0 * $0
    }.reduce(0, +) / Float(buffer.frameLength))
    
    let avgPower = 20 * log10(rms)
    let meterLevel = meterLookup(power: avgPower)
    return meterLevel >= 0.60 ? .sound : .silence
  }
  
  private func meterLookup(power: Float) -> Float {
    guard power.isFinite else {
      return 0.0
    }
    
    let minDb: Float = -80
    
    if power < minDb {
      return 0.0
      
    } else if power >= 1.0 {
      return 1.0
      
    } else {
      return (abs(minDb) - abs(power)) / abs(minDb)
    }
  }
}
