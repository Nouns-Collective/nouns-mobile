//
//  VoiceCapturePersistency.swift
//  
//
//  Created by Ziad Tamim on 13.02.22.
//

import Foundation
import AVFAudio
import os

final class VoiceCaptureOutput {
  
  ///
  private(set) var audioFile: AVAudioFile
  
  ///
  var isEmpty: Bool {
    audioFile.length > 0
  }
  
  ///
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "VoiceCapturePersistency"
  )
  
  init(audioFormat: AVAudioFormat) throws {
    /// Generates a new `AVAudioFile` given the audio format.
    let fileURL = Self.generateUniqueFileURL()
    audioFile = try AVAudioFile(forWriting: fileURL, settings: audioFormat.settings)
  }
  
  deinit {
    deleteFile(at: audioFile.url)
  }
  
  // MARK: - Audio Management
  
  func persistStream(
    _ buffer: AVAudioPCMBuffer
  ) throws {
      try audioFile.write(from: buffer)
  }
  
  // MARK: - File management
  
  static private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("caf")
    return fileURL
  }
  
  private func deleteFile(at fileURL: URL) {
    do {
      try FileManager.default.removeItem(at: fileURL)
    } catch {
      logger.error("⚠️ 🔊 Couldn't delete audio file: \(error.localizedDescription, privacy: .public)")
    }
  }
}
