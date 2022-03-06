//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-02.
//

import SwiftUI
import Combine

/// A view to display an animated sequence of images, like a flip book
public struct ImageSequence: View {
  
  @State private var image: Image = Image("")
  
  /// The names of the images to use for the sequence
  @State private var images: [String]
  
  /// The desired fps (frames per second) to animate the sequence at
  private let fps: CGFloat
  
  private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
  
  @State private var imageIndex: Int = 0
    
  public init(images: [String], fps: CGFloat = 30) {
    self.images = images
    self.fps = fps
    self.timer = Timer.publish(every: 1 / fps, on: .main, in: .common).autoconnect()
  }
  
  public var body: some View {
    Group {
      image
        .centerCropped()
    }
    .onReceive(timer) { _ in
      self.animate()
    }
    .onDisappear {
      self.clear()
    }
  }
  
  private func animate() {
    if imageIndex < self.images.count {
      let uiImage = UIImage(named: self.images[imageIndex])!
      self.image = Image(uiImage: uiImage)
      imageIndex += 1
    } else {
      imageIndex = 0
    }
  }
  
  private func clear() {
    timer.upstream.connect().cancel()
    images.removeAll()
  }
}
