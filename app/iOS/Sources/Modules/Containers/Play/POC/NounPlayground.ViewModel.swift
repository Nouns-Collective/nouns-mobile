//
//  NounPlayground.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI
import Services

extension NounPlayground {
  
  final class ViewModel: ObservableObject {
    
    @Published private(set) var selectedEffect: AudioService.AudioEffect = .alien
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var nouns: [Noun] = []
    
    private let audioService: AudioService
    private let offChainNounService: OffChainNounsService
    
    init(audioService: AudioService = AudioService(), offChainNounService: OffChainNounsService = AppCore.shared.offChainNounsService) {
      self.audioService = audioService
      self.offChainNounService = offChainNounService
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
    
    /// Fetch off chain nouns to allow the user to scroll through the noun they want to play with
    func fetchOffChainNouns() {
      // This only needs to be called once as a new noun cannot be created
      // while the user is in the playground experience
      // As such, there's no need to watch for changes
      
      do {
        self.nouns = try offChainNounService.fetchNouns(ascending: true)
      } catch {
        // Present an error
      }
    }
  }
}
