//
//  PlayRecord.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI

extension PlayRecord {
  
  @MainActor
  final class ViewModel: ObservableObject {
    
    @Published private(set) var selectedEffect: AudioService.AudioEffect = .alien
    @Published private(set) var isRecording: Bool = false
    
    private let audioService: AudioService
    
    init(audioService: AudioService = AudioService()) {
      self.audioService = audioService
    }
    
    /// Requests the user's permission to use the microphone
    func requestMicrophonePermission(completion: @escaping (Bool, Error?) -> Void) {
      audioService.requestPermission(completion: completion)
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func startListening() {
      audioService.startListening()
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func stopListening() {
      audioService.stopListening()
    }
    
    /// Updates the currently selected effect
    func updateEffect(to effect: AudioService.AudioEffect) {
      self.selectedEffect = effect
    }
    
    /// Toggles the `isRecording` boolean value
    func toggleRecording() {
      isRecording.toggle()
    }
  }
}
