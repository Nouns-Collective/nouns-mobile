//
//  ENSText.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-15.
//

import SwiftUI

struct AddressLabel: View {
  
  let token: String
  
  var body: some View {
    Text(token)
      .lineLimit(1)
      .truncationMode(.middle)
  }
}

struct ENSText<P>: View where P: View {
  
  @StateObject var viewModel: ViewModel
  
  /// A placeholder view to display while the domain is loading
  @ViewBuilder
  let placeholder: P
  
  var body: some View {
    Text(viewModel.ens ?? "")
      .emptyPlaceholder(when: viewModel.ens == nil) {
        placeholder
      }
      .onAppear {
        viewModel.fetchENS()
      }
  }
}

extension ENSText {
  
  final class ViewModel: ObservableObject {
    var token: String
    @Published var ens: String?
    
    init(token: String) {
      self.token = token
    }
    
    @MainActor
    func fetchENS() {
      Task {
        do {
          ens = try await AppCore.shared.ensNameService.domainLookup(address: token)
        } catch {}
      }
    }
  }
}
