//
//  NounderActivitySheet.swift
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
struct NounderActivitiesSheet: View {
  
  @Binding var isPresented: Bool
  
  var body: some View {
    VStack {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 2) {
          Text("bobby.eth")
            .font(.title)
            .fontWeight(.semibold)
          
          Text("DAO Activity")
            .font(.headline)
            .fontWeight(.regular)
        }
        
        Spacer()
        
        SoftButton(systemImage: "xmark", action: {
          isPresented.toggle()
        })
      }.padding(.bottom, 40)
      
      VStack(spacing: 40) {
        ForEach(0..<4) { _ in
          HStack {
            Label(title: {
              Text("Voted for Nouns Bidder POAP")
                .font(Font.system(size: 18, weight: .regular, design: .default))
            }, icon: {
              Image(systemName: "hand.thumbsup.fill")
                .foregroundColor(Color.componentNuclear)
            })
            
            Spacer()
            Text("Succeeded")
              .bold()
              .font(Font.system(size: 13, design: .default))
              .foregroundColor(Color.white)
              .padding(.horizontal, 12)
              .padding(.vertical, 4)
              .background(Color.componentNuclear)
              .clipShape(Capsule())
          }
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
  }
}

struct NounderActivitiesSheet_Previews: PreviewProvider {
  static var previews: some View {
    NounderActivitiesSheet(isPresented: .constant(true))
  }
}
