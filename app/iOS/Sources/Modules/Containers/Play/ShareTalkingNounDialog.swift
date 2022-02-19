//
//  SharePlayExperienceDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 13.02.22.
//

import SwiftUI
import UIComponents
import Services

///
struct ShareTalkingNounDialog: View {
  
  /// A value that identifies the location of the video to be shared.
  let videoURL: URL?
  
  /// The completed fraction of the video preparation task represented by the progress view.
  let progressValue: Double
  
  /// A boolean indicates whether the activity sharing sheet is presented.
  @State private var isShareSheetPresented = false
  
  var body: some View {
    ActionSheet(
      title: "Share it!",
      borderColor: nil
    ) {
      Text("Get ready! Your video will be ready soon.")
        .font(.custom(.regular, size: 17))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      if videoURL != nil {
        SoftButton(
          text: "Share this",
          largeAccessory: { Image.share },
          action: { })
          .controlSize(.large)
        
      } else {
        SoftProgress(value: progressValue, text: "Preparing video...")
      }
      
      SoftButton(
        text: "Start over",
        largeAccessory: { Image.retry },
        action: {
          withAnimation {
            
          }
        })
        .controlSize(.large)
    }
    .padding(.bottom, 4)
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = videoURL {
        ShareSheet(activityItems: [url])
      }
    }
  }
}
