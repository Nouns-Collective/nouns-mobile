//
//  RecordButton.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-03.
//

import SwiftUI
import Combine

/// A button designed for recording feedback. Holding the button will present a gradient
/// stroke around the circular button, which will rotate until it completes a lap. The duration of this animation
/// depends on the `maximumRecordDuration` when initializing this button.
public struct RecordButton: View {
  
  /// Specify whether the record button is held down.
  @Binding var isRecording: Bool
  
  /// The maximum duration a user can hold on the button (to record), in seconds
  public let maximumRecordDuration: CGFloat
  
  /// Coachmark showing the current record state.
  public let coachmark: String
  
  /// Gesture state that would be `true` when the user is holding the button
  @GestureState private var isTapped: Bool = false {
    didSet {
      // Updates the current state when the user hold up and down on the button.
      isRecording = isTapped
    }
  }
  
  /// A progress indicator, ranging from 0.0 (not started) to the value of `maximumRecordDuration` (complete)
  @State private var elapsedTime: CGFloat = 0.0
  
  /// The recording progress where the maximum value (1.0) is reached when the `maximumRecordDuration` is reached
  private var progressValue: CGFloat {
    elapsedTime / maximumRecordDuration
  }
  
  /// A timer to update the stroke around the button while recording
  private let progressTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
  
  private let gradient = AngularGradient(
    gradient: SwiftUI.Gradient(colors: GradientColors.recordButtonStroke.colors),
    center: .center,
    startAngle: .degrees(360),
    endAngle: .degrees(0))
  
  private var dragGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .updating($isTapped) { (_, isTapped, _) in
        isTapped = true
      }
  }
  
  private var foregroundColor: Color {
    isTapped ? Color.componentNounsBlack.opacity(0.15) : Color.white
  }
  
  private var strokeWidth: CGFloat {
    isTapped ? 0 : 2
  }
  
  public init(
    _ isRecording: Binding<Bool>,
    maximumRecordDuration: CGFloat = 20.0,
    coachmark: String
  ) {
    self._isRecording = isRecording
    self.maximumRecordDuration = maximumRecordDuration
    self.coachmark = coachmark
  }
  
  public var body: some View {
    VStack {
      ZStack {
        Circle()
          .strokeBorder(Color.componentNounsBlack, lineWidth: strokeWidth)
          .background(Circle().fill(foregroundColor))
          .frame(width: 72, height: 72, alignment: .center)
          .animation(.spring(), value: isTapped)
          .gesture(dragGesture)
        
        Circle()
          .trim(from: 0, to: progressValue)
          .stroke(gradient, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
          .rotationEffect(.degrees(-90))
          .frame(width: 100, height: 100)
      }
      
      Text(coachmark)
        .font(.custom(.medium, size: 17))
        .foregroundColor(Color.componentNounsBlack)
        .hidden(isTapped)
    }
    .onChange(of: isTapped, perform: { _ in
      self.elapsedTime = 0.0
    })
    .onReceive(progressTimer) { _ in
      // Only progress the `elapsedTime` when holding the button
      guard isTapped else { return }
      elapsedTime += 0.01
    }
  }
}

struct RecordButton_Previews: PreviewProvider {
  
  init() {
    UIComponents.configure()
  }
  
  static var previews: some View {
    VStack {
      RecordButton(.constant(false), coachmark: "Hold to record")
    }
    .ignoresSafeArea()
    .background(Gradient.bubbleGum)
  }
}
