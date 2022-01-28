//
//  RecordButton.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-27.
//

import SwiftUI

extension NounPlayground {
  
  struct RecordButton: View {
    
    @Binding var isRecording: Bool
    @GestureState private var isDetectingLongPress = false
    
    private var longPress: some Gesture {
      LongPressGesture(minimumDuration: 3)
        .updating($isDetectingLongPress) { currentState, gestureState, _ in
          gestureState = currentState
        }
    }
    
    var body: some View {
      Circle()
        .foregroundColor(isDetectingLongPress ? Color.white.opacity(0.75) : Color.white)
        .frame(width: isDetectingLongPress ? 70 : 75, height: isDetectingLongPress ? 70 : 75)
        .gesture(longPress)
        .animation(.spring(), value: isDetectingLongPress)
        .onChange(of: isDetectingLongPress) { isPressing in
          isRecording = isPressing
        }
    }
  }
}

struct RecordButton_Previews: PreviewProvider {
  static var previews: some View {
    NounPlayground.RecordButton(isRecording: .constant(true))
      .background(Color.black)
  }
}
