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
  
  /// An object that represents an audio file that the system can open for reading or writing
  private(set) var audioFile: AVAudioFile
  
  var duration: TimeInterval {
    let sampleRateSong = Double(audioFile.fileFormat.sampleRate)
    let lengthSongSeconds = Double(audioFile.length) / sampleRateSong
    return lengthSongSeconds
  }
  
  ///
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "VoiceCaptureOutput"
  )
  
  init(audioFormat: AVAudioFormat) throws {
    /// Generates a new `AVAudioFile` given the audio format.
    let audioFileURL = Self.generateUniqueFileURL()
    audioFile = try AVAudioFile(forWriting: audioFileURL, settings: audioFormat.settings)
  }
  
  func reset() {
    deleteFile(at: audioFile.url)
  }
  
  // MARK: - Audio Management
  
  func persistStream(
    _ buffer: AVAudioPCMBuffer
  ) throws {
    let audioFileURL = audioFile.url
    let audioSettings = audioFile.fileFormat.settings
    
    if !FileManager.default.fileExists(atPath: audioFileURL.path) {
      audioFile = try AVAudioFile(forWriting: audioFileURL, settings: audioSettings)
    }
    
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
