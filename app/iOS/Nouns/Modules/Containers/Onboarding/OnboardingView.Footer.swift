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

extension OnboardingView {
  
  struct Footer<Trailing: View>: View {
    let page: Page
    let title: String
    let trailing: () -> Trailing
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.custom(.bold, relativeTo: .title2))
          .foregroundColor(Color.componentNounsBlack)
          .multilineTextAlignment(.leading)
          .minimumScaleFactor(0.5)
          .frame(height: 90, alignment: .topLeading)
        
        Spacer()
        
        HStack(alignment: .bottom) {
          PageIndicator(
            pages: OnboardingView.Page.allCases,
            selection: page
          )
          
          Spacer()
          
          trailing()
        }
      }
      .padding(30)
      .padding(.bottom, 30)
      .background(Color.clear)
      .border(width: 2, edges: [.top], color: .componentNounsBlack)
    }
  }
}
