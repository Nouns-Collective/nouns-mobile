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
  
  var animation: Namespace.ID
  @Binding var selected: Int?
  @Binding var isPresentingActivity: Bool
  
  var body: some View {
    ForEach(0..<5) { num in
      if let selected = selected, selected == num {
        OnChainNounProfileCard(animation: animation, noun: "Noun \(num)", date: "Oct 11 2021", owner: "bob.eth", isShowingActivity: $isPresentingActivity)
          .id(num)
          .matchedGeometryEffect(id: "noun-\(num)", in: animation)
          .padding(.horizontal, -20)
      } else {
        OnChainNounCard(animation: animation, noun: "Noun \(num)", date: "Oct 11 2021", owner: "bob.eth")
          .id(num)
          .matchedGeometryEffect(id: "noun-\(num)", in: animation)
          .onTapGesture {
            withAnimation(.spring()) {
              selected = num
            }
          }
      }
    }
  }
}
