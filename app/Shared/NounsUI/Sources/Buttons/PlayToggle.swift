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

public struct PlayToggle: View {
  
  /// A binding to a Boolean value that indicates whether the control is the in play or pause state.
  @Binding var isPlaying: Bool
  
  public var body: some View {
    SoftButton {
      HStack {
        Text(isPlaying ? "Pause" : "Play")
          .font(.custom(.medium, relativeTo: .subheadline))
          
        Image.Controls.play
          .resizable()
          .frame(width: 20, height: 20)
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      
    } action: {
      isPlaying.toggle()
    }
  }
}

struct PlayToggle_Previews: PreviewProvider {
  
  init() {
    NounsUI.configure()
  }
  
  static var previews: some View {
    PlayToggle(isPlaying: .constant(false))
  }
}
