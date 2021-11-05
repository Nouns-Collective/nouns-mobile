//
//  NounderActivitySheet.swift
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
func nounActivitiesReducer(state: ActivitiesState, action: ActivityAction) -> ActivitiesState {
  fatalError("\(#function) must be implemented.")
}

/// <#Description#>
struct ActivitiesState {
  
}

/// <#Description#>
enum ActivityAction {
  case fetch(Noun)
  case success([Activity])
  case failure(Error)
}


/// <#Description#>
struct NounderActivitiesSheet: View {
  
  var body: some View {
    Text("Nounder Activity Sheet.")
  }
}
