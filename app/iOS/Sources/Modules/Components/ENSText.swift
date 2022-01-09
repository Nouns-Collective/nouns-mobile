//
//  ENSText.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-15.
//

import SwiftUI
import Services

/// Loads the decentralised name for a given token.
struct ENSText: View {
  @State private var domain: String?
  
  private let ensService: ENS
  private let token: String
  
  init(
    token: String,
    ensService: ENS = AppCore.shared.ensNameService
  ) {
    self.token = token
    self.ensService = ensService
  }
  
  var body: some View {
    Text(domain ?? token)
      .lineLimit(1)
      .truncationMode(.middle)
      .task {
        await fetchENS()
      }
  }
  
  @MainActor
  private func fetchENS() async {
    do {
      domain = try await ensService.domainLookup(address: token)
    } catch { }
  }
}
