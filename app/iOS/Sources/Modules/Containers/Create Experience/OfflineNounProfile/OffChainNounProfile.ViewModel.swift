//
//  OffChainNounProfile.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 18.12.21.
//

import Foundation
import Services

extension OffChainNounProfile {
  
  final class ViewModel: ObservableObject {
    
    /// The current represented noun.
    @Published var noun: Noun
    
    /// A string indicate the noun birthday in long date style.
    @Published private(set) var nounBirthdate: String
    
    /// A boolean to present the playground with the use of the current noun.
    @Published var isPlayPresented: Bool = false
    
    @Published var isRenamePresented: Bool = false
    
    @Published var isDeletePresented: Bool = false
    
    @Published var isShareSheetPresented: Bool = false
    
    @Published var shouldShowNounCreator: Bool = false
    
    /// The image data of the noun to export and share
    @Published var exportImageData: Data?
        
    private let service: OffChainNounsService
    
    init(
      noun: Noun,
      service: OffChainNounsService = AppCore.shared.offChainNounsService
    ) {
      self.noun = noun
      self.service = service
      
      nounBirthdate = noun.createdAt.formatted(dateStyle: .long)
    }
    
    func deleteNoun() {
      do {
        try service.delete(noun: noun)
      } catch {
        print("Error: \(error)")
      }
    }
    
    func saveChanges() {
      do {
        try service.store(noun: noun)
      } catch {
        print("Error: \(error)")
      }
    }
    
    func didEdit(seed: Seed) {
      noun.seed = seed
      saveChanges()
    }

    func onShare() {
      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.shareOffchainNoun,
                                        parameters: ["noun_name": noun.name])
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.offchainNounProfile)
    }
  }
}
