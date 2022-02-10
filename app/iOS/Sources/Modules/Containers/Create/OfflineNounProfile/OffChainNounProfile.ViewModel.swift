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
    
    @Published var isRenamePresented: Bool = false
    
    @Published var isDeletePresented: Bool = false
    
    @Published var isShareSheetPresented: Bool = false
    
    @Published var shouldShowNounCreator: Bool = false
    
    /// The image data of the noun to export and share
    var exportImageData: Data?
        
    init(
      noun: Noun,
      service: OffChainNounsService = AppCore.shared.offChainNounsService
    ) {
      self.noun = noun
      self.service = service
    }
    
    var nounBirthdate: String {
      noun.createdAt.formatted()
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
  }
}
