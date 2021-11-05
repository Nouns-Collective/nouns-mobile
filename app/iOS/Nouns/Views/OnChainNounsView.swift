//
//  OnChainNounsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Services

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
/// - Returns: <#description#>
func onChainNounsReducer(state: OnChainNounsState, action: OnChainNounsAction) -> OnChainNounsState {
  fatalError("\(#function) must be implemented.")
}

/// <#Description#>
struct OnChainNounsState {
  
}

/// <#Description#>
enum OnChainNounsAction {
  case fetch
  case success([Noun])
  case failure(Error)
}

/// <#Description#>
struct OnChainNounsView: View {
  
    var body: some View {
        Text("On Chains Nouns View")
    }
}
