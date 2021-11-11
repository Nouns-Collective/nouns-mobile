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
  
  let columns = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20)
  ]
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 20) {
      ForEach(0..<6) { num in
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

struct Previews: PreviewProvider {
  
  struct TestView: View {
    @Namespace var ns
    
    var body: some View {
      OnChainNounsView(animation: ns, selected: .constant(nil), isPresentingActivity: .constant(false))
    }
  }
  
  static var previews: some View {
    TestView()
  }
}
