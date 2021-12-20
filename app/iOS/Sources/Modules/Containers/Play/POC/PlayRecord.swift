//
//  PlayRecord.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-05.
//

import SwiftUI
import Services
import UIComponents
import Combine
import SpriteKit

let mouthSequence = [
  R.image.headApeMouth1.name,
  R.image.headApeMouth2.name,
  R.image.headApeMouth3.name,
  R.image.headApeMouth4.name,
]

let blinkEyes = [
  R.image.eyesBlink1.name,
  R.image.eyesBlink2.name,
  R.image.eyesBlink3.name,
  R.image.eyesBlink4.name,
]

let shiftEyes = [
  R.image.eyesShift1.name,
  R.image.eyesShift2.name,
  R.image.eyesShift3.name,
  R.image.eyesShift4.name,
  R.image.eyesShift5.name,
  R.image.eyesShift6.name,
]

public struct ImageSequence: UIViewRepresentable {
  private let sequence: [String]
  private let duration: Double
  /// Creates and returns an animated image from a given name `gif` file.
  /// - Parameters:
  ///   - named: The name of the gif file.
  ///   - bundle: A representation of the resources stored in a bundle directory on disk.
  public init(_ sequence: [String], duration: Double = 0.2) {
    self.sequence = sequence
    self.duration = duration
  }
  
  public func makeUIView(context: Context) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = sequence.compactMap { UIImage(named: $0) }.first
    imageView.layer.minificationFilter = .nearest
    imageView.layer.magnificationFilter = .nearest
    imageView.animationImages = sequence.compactMap { UIImage(named: $0) }
    imageView.animationDuration = duration
    defer { imageView.startAnimating() }
    return imageView
  }
  
  public func updateUIView(_ uiView: UIImageView, context: Context) {
    uiView.animationImages = sequence.compactMap { UIImage(named: $0) }
    uiView.animationDuration = duration
    uiView.startAnimating()
  }
}

struct RecordButton: View {
  @Namespace var namespace
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
            .matchedGeometryEffect(id: "shape", in: namespace)
            .padding(25)
        } else {
          Circle()
            .fill(Color.componentRaspberry)
            .matchedGeometryEffect(id: "shape", in: namespace)
            .padding(5)
        }
        
        Circle()
          .strokeBorder(Color.componentRaspberry, lineWidth: 2.5)
      }
    }
  }
}

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    return path
  }
}

let nounGameScene = NounGameScene(size: CGSize(width: 320, height: 320))

struct PlayRecord: View {
  @Namespace var animation
  @Binding var isPresented: Bool
  @State var hasRecorded: Bool = false
  @State var isRecording: Bool = false
  
  @StateObject private var recorder = AudioRecorder()
  
  var subscriptions = Set<AnyCancellable>()
  
  var scene: SKScene {
    nounGameScene.scaleMode = .fill
    return nounGameScene
  }
  
  var body: some View {
    VStack(spacing: 50) {
      ZStack {
        SpriteView(scene: scene, options: [.allowsTransparency])
          .frame(width: 320, height: 320)
      }
      .padding(.top, -50)
      
      VStack {
        HStack(alignment: .center, spacing: 8) {
          Spacer()
          
          Menu {
            ForEach(AudioRecorder.Pitch.allValues) { pitch in
              Button {
                recorder.adjustPitch(to: pitch)
              } label: {
                Text("\(pitch.string)")
              }
            }
          } label: {
            Label("Pitch", systemImage: "waveform")
              .padding(.horizontal, 18)
              .padding(.vertical, 12)
              .background(Color.white)
              .clipShape(Capsule())
              .foregroundColor(Color.black)
          }
          
          Menu {
            ForEach(AudioRecorder.Speed.allValues) { speed in
              Button {
                recorder.adjustSpeed(to: speed)
              } label: {
                Text("x\(speed.string)")
              }
            }
          } label: {
            Label("Speed", systemImage: "hare.fill")
              .padding(.horizontal, 18)
              .padding(.vertical, 12)
              .background(Color.white)
              .clipShape(Capsule())
              .foregroundColor(Color.black)
          }
          
          Spacer()
        }
        .padding(.bottom, 50)
        .frame(height: 40)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.back },
        action: { isPresented.toggle() })
      
    }, rightAccessory: { EmptyView() })
    .background(Gradient.bubbleGum)
    .onAppear {
      // Request permission to use microphone
      recorder.requestPermission { [weak recorder] success, error in
        if success {
          recorder?.startRecording()
        } else {
          if let error = error {
            print("Error: \(error)")
          }
        }
      }
    }
    .onDisappear {
      recorder.stopRecording()
    }
  }
}
