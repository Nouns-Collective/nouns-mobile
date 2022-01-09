//
//  RecordButton.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI

extension NounPlayground {

  struct RecordButton: View {
    @Namespace var animatingShapeNamespace
    @Binding var isRecording: Bool
    
    var body: some View {
      Button {
        withAnimation {
          isRecording.toggle()
        }
      } label: {
        ZStack {
          if isRecording {
            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
              .fill(Color.componentRaspberry)
              .matchedGeometryEffect(id: "shape", in: animatingShapeNamespace)
              .padding(25)
          } else {
            Circle()
              .fill(Color.componentRaspberry)
              .matchedGeometryEffect(id: "shape", in: animatingShapeNamespace)
              .padding(5)
          }
          
          Circle()
            .strokeBorder(Color.componentRaspberry, lineWidth: 2.5)
        }
      }
    }
  }
}
