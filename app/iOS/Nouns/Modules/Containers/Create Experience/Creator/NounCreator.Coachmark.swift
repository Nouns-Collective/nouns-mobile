// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI

extension NounCreator {
  
  struct CreateCoachmarks: View {
    @ObservedObject var viewModel: ViewModel
    
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
      .hidden(viewModel.isExpanded)
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
        Text(R.string.createCoachmark.shake())
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
        Text(R.string.createCoachmark.swipe(viewModel.currentModifiableTraitType.description.lowercased()))
          .font(.custom(.medium, relativeTo: .callout))
          .foregroundColor(.componentNounsBlack)
      }
    }
  }
}
