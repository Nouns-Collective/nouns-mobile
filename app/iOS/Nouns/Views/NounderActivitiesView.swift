//
//  NounderActivitiesView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Services
import UIComponents

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
struct NounderActivitiesView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    Text("Activities")
  }
}

struct NounderActivitiesSheet_Previews: PreviewProvider {
  static var previews: some View {
    NounderActivitiesSheet(isPresented: .constant(true))
  }
}
