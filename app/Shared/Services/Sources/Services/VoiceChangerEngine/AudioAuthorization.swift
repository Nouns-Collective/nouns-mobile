// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
