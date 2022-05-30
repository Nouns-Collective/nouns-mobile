//
//  Nounfetti.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-03-23.
//

import SwiftUI
import UIComponents

struct NounfettiView: View {
  
  private struct Nounfetti: Decodable {
    let frames: [String]
  }
  
  @State private var frames: [String] = []
  
  private func loadNounfetti() throws {
    guard let url = Bundle.main.url(forResource: "nounfetti", withExtension: "json"),
          let data = try? Data(contentsOf: url) else { return }
    
    self.frames = try JSONDecoder().decode(Nounfetti.self, from: data).frames
  }
  
  var body: some View {
    ImageSlideshow(images: frames, atlas: "nounfetti", repeats: false)
      .zIndex(100)
      .ignoresSafeArea()
      .allowsHitTesting(false)
      .onAppear {
        try? loadNounfetti()
      }
  }
}

struct Nounfetti_Previews: PreviewProvider {
  static var previews: some View {
    NounfettiView()
  }
}
