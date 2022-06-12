// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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
import SpriteKit

struct PlayExperience: View {
  @StateObject var viewModel: ViewModel 
  
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  @Environment(\.outlineTabBarVisibility) var outlineTabBarVisibility

  @State private var isNounPickerPresented: Bool = false
  
  /// A view that displays the talking noun scene below the speech bubble.
  ///
  /// - Returns: This view contains the play scene to animate the eyes and mouth.
  private let talkingNoun: TalkingNoun
  
  /// Holds a reference to the localized text.
  private let localize = R.string.playExperience.self
  
  init(viewModel: ViewModel = ViewModel()) {
    _viewModel = StateObject(wrappedValue: viewModel)
    talkingNoun = TalkingNoun(seed: viewModel.seed)
  }
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 0) {
        Text(localize.subheadline())
          .font(.custom(.regular, relativeTo: .subheadline))
        
        VStack(spacing: 0) {
          VStack(spacing: -40) {
            SpeechBubble(localize.speechBubble())
            
            SpriteView(scene: talkingNoun, options: [.allowsTransparency])
              .frame(width: 320, height: 320)
          }
        
          // Navigation link showing the noun selection to choose from
          Link(isActive: $isNounPickerPresented, content: {
            OutlineButton(
              text: localize.proceedTitle(),
              largeAccessory: { Image.fingergunsRight.shakeRepeatedly() },
              action: { isNounPickerPresented.toggle() })
              .controlSize(.large)
            
          }, destination: {
            PlayNounPicker()
          })
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun
      // card and the top of the tab view.
      .padding(.bottom, 20)
      .softNavigationTitle(localize.title())
      .background(Gradient.blueberryJam)
      .ignoresSafeArea(edges: .top)
      .onAppear {
        outlineTabBarVisibility.show()
      }
    }
  }
}
