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
import SoundAnalysis
import Combine
import os

/// Various audio states.
public enum AudioStatus: String {
  case undefined
  case speech
  case silence
}

/// A class for listening to live system audio input, and for performing sound
/// classification using Sound Analysis.
protocol AudioStateDetector: AnyObject {
  
  /// The current audio state.
  var status: AudioStatus { get }
  
  /// The previous audio state.
  var previousState: AudioStatus { get }
  
  func process(buffer: AVAudioPCMBuffer, sampleTime: AVAudioFramePosition)
}

final class MLAudioStateDetector: AudioStateDetector {
  
  private(set) var status: AudioStatus = .undefined
  private(set) var previousState: AudioStatus = .undefined
  
  /// An analyzer that performs sound classification.
  private var analyzer: SNAudioStreamAnalyzer
  
  private static let speechClassificationLabel = "speech"
  
  /// Indicates the amount of audio, in seconds, that informs a prediction.
  private let inferenceWindowSize = Double(1.0)
  
  ///
  private let subject = PassthroughSubject<SNClassificationResult, Error>()
  
  ///
  private var detectionCancellable: AnyCancellable?
  
  /// An array of sound analysis observers that the class stores to control their lifetimes.
  ///
  /// To perform sound classification, the app registers an observer and a request with an analyzer. While
  /// registered, the analyzer claims a strong reference on the request and not on the observer. It's the
  /// responsibility of the caller to handle the observer's lifetime. When sound classification isn't active,
  /// the variable is `nil`, freeing the observers from memory.
  private var resultsObserver: SNResultsObserving?
  
  /// The last detected
  private var lastSpeechState: AudioDetectionState?
  
  /// The amount of overlap between consecutive analysis windows.
  ///
  /// The system performs sound classification on a window-by-window basis. The system divides an
  /// audio stream into windows, and assigns labels and confidence values. This value determines how
  /// much two consecutive windows overlap. For example, 0.9 means that each window shares 90% of
  /// the audio that the previous window uses.
  private let overlapFactor = Double(0.9)
  
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "AudioStateDetector"
  )
  
  init(audioFormat: AVAudioFormat) throws {
    analyzer = SNAudioStreamAnalyzer(format: audioFormat)
    
    try prepare()
  }
  
  deinit {
    analyzer.removeAllRequests()
    resultsObserver = nil
  }
  
  private func prepare() throws {
    let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
    request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 100_000)
    request.overlapFactor = overlapFactor
    
    let resultsObserver = ClassificationResults(subject: subject)
    try analyzer.add(request, withObserver: resultsObserver)
    self.resultsObserver = resultsObserver
    
    lastSpeechState = AudioDetectionState(presenceThreshold: 0.4,
                                          absenceThreshold: 0.3,
                                          presenceMeasurementsToStartDetection: 1,
                                          absenceMeasurementsToEndDetection: 2)
    
    detectionCancellable = subject.sink { completion in
      
      switch completion {
      case .finished:
        self.logger.info("🎙 Sound detection is stopped")
      case .failure(let error):
        self.logger.error("⚠️ 🎙 Sound detection is stopped due to \(error.localizedDescription)")
      }
      
    } receiveValue: { [weak self] result in
      guard let self = self else { return }
      guard let lastSpeechState = self.lastSpeechState else {
        self.logger.error("⚠️ 🎙 Couldn't analyse the sound as no initial speech state was found.")
        return
      }
      
      self.lastSpeechState = Self.advanceDetectionStates(
        lastSpeechState,
        soundLabel: Self.speechClassificationLabel,
        givenClassificationResult: result
      )
      
      self.previousState = self.status
      self.status = lastSpeechState.isDetected ? .speech : .silence
    }
  }
  
  /// Updates the detection states according to the latest classification result.
  ///
  /// - Parameters:
  ///   - oldState: The previous detection states to update with a new observation from an ongoing
  ///   sound classification.
  ///   - result: The latest observation the app emits from an ongoing sound classification.
  ///
  /// - Returns: A new array of sounds with their updated detection states.
  static fileprivate func advanceDetectionStates(
    _ oldState: AudioDetectionState,
    soundLabel: String,
    givenClassificationResult result: SNClassificationResult
  ) -> AudioDetectionState {
    let confidenceForLabel = { (soundLabel: String) -> Double in
      let confidence: Double
      if let classification = result.classification(forIdentifier: soundLabel) {
        confidence = classification.confidence
      } else {
        confidence = 0
      }
      
      return confidence
    }
    
    return AudioDetectionState(
      advancedFrom: oldState,
      currentConfidence: confidenceForLabel(soundLabel)
    )
  }
  
  func process(buffer: AVAudioPCMBuffer, sampleTime: AVAudioFramePosition) {
    analyzer.analyze(buffer, atAudioFramePosition: sampleTime)
  }
}
