//
//  NounCreator.Coachmark.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-03-24.
//

import SwiftUI
import UIComponents

extension NounCreator {
  
  struct CreateCoachmarks: View {
    @ObservedObject var viewModel: ViewModel
    let isExpanded: Bool
    
    var body: some View {
      Group {
        if viewModel.showShakeCoachmark {
          ShakeCoachmark()
            .animation(.easeInOut, value: viewModel.showShakeCoachmark)
        } else if viewModel.showSwipingCoachmark {
          SwipeCoachmark(viewModel: viewModel)
            .animation(.easeInOut, value: viewModel.showSwipingCoachmark)
        }
      }
      .hidden(isExpanded)
    }
  }
  
  /// A coachmark instructing users to shake their phone in order to shuffle the noun's seed
  struct ShakeCoachmark: View {
    
    var body: some View {
      VStack(alignment: .center) {
        Image.shakePhone
          .resizable()
          .frame(width: 32, height: 32, alignment: .center)
          .shakeRepeatedly(axis: [.horizontal, .vertical], rest: 1.5, centered: true)
        Text("Shake to shuffle")
          .font(.custom(.medium, relativeTo: .callout))
          .foregroundColor(.componentNounsBlack)
      }
    }
  }
  
  /// A coachmark instructing users to swipe between traits
  struct SwipeCoachmark: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(alignment: .center) {
        Image.swipePick
          .resizable()
          .frame(width: 32, height: 32, alignment: .center)
          .shakeRepeatedly(shakeCount: 1, offset: 10, rest: 1.5, centered: true)
        Text("Swipe to pick \(viewModel.currentModifiableTraitType.description.lowercased())")
          .font(.custom(.medium, relativeTo: .callout))
          .foregroundColor(.componentNounsBlack)
      }
    }
  }
}
