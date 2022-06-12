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
import Services

///
struct ShareTalkingNounDialog: View {
  
  /// A value that identifies the location of the video to be shared.
  let videoURL: URL?
  
  /// The completed fraction of the video preparation task represented by the progress view.
  let progressValue: Double
  
  ///
  let reset: () -> Void
  
  /// A boolean indicates whether the activity sharing sheet is presented.
  @State private var isShareSheetPresented = false
  
  var body: some View {
    ActionSheet(
      title: "Share it!"
    ) {
      Text("Get ready! Your video will be ready soon.")
        .font(.custom(.regular, relativeTo: .subheadline))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      if videoURL != nil {
        SoftButton(
          text: "Share this",
          largeAccessory: { Image.share },
          action: { isShareSheetPresented.toggle() })
          .controlSize(.large)
        
      } else {
        SoftProgress(value: progressValue, text: "Preparing video...")
      }
      
      SoftButton(
        text: "Start over",
        largeAccessory: { Image.retry },
        action: {
          withAnimation {
            reset()
          }
        })
        .controlSize(.large)
    }
    .padding(.bottom, 4)
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = videoURL {
        ShareSheet(activityItems: [url]) { _, _, _, _ in
          reset()
        }
      }
    } 
  }
}
