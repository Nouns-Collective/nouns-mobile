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
    let noun: Noun
    
    init(noun: Noun) {
      self.noun = noun
    }
    
    var nounBirthday: String {
      noun.createdAt.formatted()
    }
  }
}
