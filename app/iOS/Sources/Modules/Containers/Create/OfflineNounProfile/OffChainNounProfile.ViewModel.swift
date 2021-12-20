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
    @Published var noun: Noun
    
    private let service: OffChainNounsService
    
    init(
      noun: Noun,
      service: OffChainNounsService = AppCore.shared.offChainNounsService
    ) {
      self.noun = noun
      self.service = service
    }
    
    var nounBirthdate: String {
      DateFormatter.string(from: noun.createdAt)
    }
    
    func deleteNoun() {
      do {
        try service.delete(noun: noun)
      } catch { }
    }
  }
}
