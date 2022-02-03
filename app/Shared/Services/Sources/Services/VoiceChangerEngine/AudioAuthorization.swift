//
//  AudioAuthorization.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFoundation

/// The permission status for recording the audio media type.
public enum RecordPermission {
  
  /// The user has not yet granted or denied the audio capture permission.
  case undetermined
  
  /// The user has explicitly granted permission for audio capture.
  case granted
  
  /// The user has explicitly denied permission for audio capture.
  case denied
  
  /// The user is not allowed to access audio capture device.
  case restricted
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
