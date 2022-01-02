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
    @Published public var selectedEffect: AudioService.AudioEffect = .alien
    @Published public var isRecording: Bool = false
    
    private let audioService: AudioService
    
    init(audioService: AudioService = AudioService()) {
      self.audioService = audioService
    }
    
    func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
      audioService.requestPermission(completion: completion)
    }
    
    func startRecording() {
      audioService.startRecording()
    }
    
    func stopRecording() {
      audioService.stopRecording()
    }
  }
}
