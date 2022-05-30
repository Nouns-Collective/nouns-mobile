//
//  OffChainNounCard.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-26.
//

import SwiftUI
import Services

extension OffChainNounCard {
  
  @MainActor
  class ViewModel: ObservableObject {
    @Published private(set) var nounBirthday: String
    
    let noun: Noun
    
    init(noun: Noun) {
      self.noun = noun
      
      nounBirthday = noun.createdAt.formatted(dateStyle: .long)
    }
  }
}
