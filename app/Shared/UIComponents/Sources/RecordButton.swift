//
//  RecordButton.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI

struct RecordButton: View {
  @Binding var isRecording: Bool
  
  @Namespace private var nsShapeAnimation
  private let idShapeAnimation = "shape"
  
  var body: some View {
    Button {
      withAnimation {
        isRecording.toggle()
      }
    } label: {
      Image(systemName: isRecording ? "circle.fill" : "stop.fill")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 100, height: 100)
        .clipped()
    }
  }
}

struct RecordButton_Preview: PreviewProvider {
  
  static var previews: some View {
    RecordButton(isRecording: .constant(true))
      .foregroundColor(.red)
  }
}
