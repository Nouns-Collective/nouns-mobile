// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
