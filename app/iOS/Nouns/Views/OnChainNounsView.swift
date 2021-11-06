//
//  OnChainNounsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Combine
import Services

/// <#Description#>
/// - Parameter service: <#service description#>
/// - Returns: <#description#>
func onChainNounsMiddleware(service: Nouns) -> Middleware<OnChainNounsState, OnChainNounsAction> {
  return { _, action in
    
    switch action {
    case .fetch:
      return service.fetchOnChainNouns(limit: 10, after: 0)
        .subscribe(on: DispatchQueue.main)
        .map { nouns in
          OnChainNounsAction.success(nouns)
        }
        .catch { error in
          Just(OnChainNounsAction.failure(error))
        }
        .eraseToAnyPublisher()
      
    default:
      return Empty().eraseToAnyPublisher()
    }
  }
}

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
/// - Returns: <#description#>
func onChainNounsReducer(state: inout OnChainNounsState, action: OnChainNounsAction) {
  switch action {
  case .fetch:
    break
    
  case .success(let nouns):
    state.nouns = nouns
    
  case .failure:
    // TODO: Error should be handled
    break
  }
}

/// <#Description#>
struct OnChainNounsState {
  var nouns: [Noun]
  
//  var activitiesState: ActivitiesState
//  var activityIndicatorState: ActivityIndicatorState = .idle
}

/// <#Description#>
enum OnChainNounsAction {
  case fetch
  case success([Noun])
  case failure(Error)
}

/// <#Description#>
struct OnChainNounsView: View {
  @EnvironmentObject var store: AppStore
  
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
