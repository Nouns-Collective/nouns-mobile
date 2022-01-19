//
//  SilenceFinder.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFoundation
import Accelerate

/// Calculates audio powers.
class SilenceFinder {

  /// The current audio state.
  private(set) var status: AudioStatus = .undefined
  
  /// -160 dB
  private let minLevel: Float = 0.000_000_01
  
  /// The threshold between loud and silent (increase to filter out noise).
  private let silenceThreshold: Float = -25
  
  /// The time interval to consider the state as `Silent` (Handles space while speaking).
  private let silenceDelay: TimeInterval = 1.0
  
  /// Records when the silence was last occured.
  private var silenceBegin: TimeInterval = Date().timeIntervalSince1970
  
  func process(buffer: AVAudioPCMBuffer)  {
    guard let channelData = buffer.floatChannelData else {
      return
    }
    
    // The mic has a single channel.
    let channelCount = Int(buffer.format.channelCount)
    let length = vDSP_Length(buffer.frameLength)
    
    // Iterating through all the channels to handle mic, left, right, surrounding...
    for channel in 0..<channelCount {
      let peak = calculatePeak(
        data: channelData[channel],
        strideFrames: buffer.stride,
        length: length
      )
      
      let now = Date().timeIntervalSince1970
      
      if peak > silenceThreshold {
        status = .loud
        // Reset the silence begining each time the signal is the loud state.
        silenceBegin = now
        
      } else if (now - silenceBegin) >= silenceDelay {
        status = .silent
      }
    }
  }
  
  private func calculatePeak(
    data: UnsafePointer<Float>,
    strideFrames: Int,
    length: vDSP_Length
  ) -> Float {
    var peak: Float = 0.0
    vDSP_maxv(data, strideFrames, &peak, length)
    return 20.0 * log10(max(peak, minLevel))
  }
}
