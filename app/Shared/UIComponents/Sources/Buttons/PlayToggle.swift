//
//  SwiftUIView.swift
//  
//
//  Created by Ziad Tamim on 08.02.22.
//

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
    UIComponents.configure()
  }
  
  static var previews: some View {
    PlayToggle(isPlaying: .constant(false))
  }
}
