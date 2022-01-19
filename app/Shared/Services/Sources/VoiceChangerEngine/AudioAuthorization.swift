//
//  AudioAuthorization.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFAudio

/// The record permission status.
public enum RecordPermission {
  case undetermined
  case denied
  case granted
}

/// Authorization for audio hardware.
public protocol AudioAuthorization {
  
  /// The current recording permission status.
  var recordPermission: RecordPermission { get }
  
  /// Requests the user’s permission to record audio.
  ///
  /// When you call this method, if the user previously granted or denied recording
  /// permission, the block executes immediately without displaying a recording
  /// permission alert. If the user hasn’t yet granted or denied permission when you
  /// call this method, the system displays a recording permission alert and executes
  /// the block after the user responds to it.
  ///
  /// - Returns: True if the user granted access.
  @discardableResult
  func requestRecordPermission() async throws -> Bool
}

extension VoiceChangerEngine: AudioAuthorization {
  
  private var audioSession: AVAudioSession {
    AVAudioSession.sharedInstance()
  }
  
  public var recordPermission: RecordPermission {
    switch audioSession.recordPermission {
    case .granted:
      return .granted
      
    case .undetermined:
      return .undetermined
      
    case .denied:
      return .denied
      
    @unknown default:
      fatalError("Unprocessed record authorization case.")
    }
  }
  
  @discardableResult
  public func requestRecordPermission() async throws -> Bool {
    try audioSession.setCategory(.playAndRecord)
    return await withCheckedContinuation({ continuation in
      audioSession.requestRecordPermission { granted in
        continuation.resume(returning: granted)
      }
    })
  }
}

