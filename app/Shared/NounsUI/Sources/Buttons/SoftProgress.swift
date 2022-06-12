// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

public struct GradientProgressStyle: ProgressViewStyle {
  /// A gradient showing the fraction completed by the progress view.
  private let gradient: Gradient
  
  public init(_ gradient: Gradient) {
    self.gradient = gradient
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    let fractionComplete = configuration.fractionCompleted ?? 0
    
    ZStack {
      GeometryReader { proxy in
        Gradient.bubbleGum
          .cornerRadius(8)
          .frame(width: fractionComplete * proxy.size.width)
      }
    }
  }
}

public struct SoftProgress: View {
  
  /// The completed fraction of the task represented by the progress view,
  /// from 0.0 (not yet started) to 1.0 (fully complete), or nil if the progress is indeterminate.
  public let value: Double?
  
  /// A label describing the task represented by the progress view.
  public let text: String
  
  public init(value: Double?, text: String) {
    self.value = value
    self.text = text
  }
  
  public var body: some View {
    SoftButton(label: {
      HStack {
        Text(text)
          .font(Font.body.weight(.medium))
        
        Spacer()
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
      
    }, action: { })
      .controlSize(.large)
      .background(
        ProgressView(value: value)
          .progressViewStyle(GradientProgressStyle(.bubbleGum))
      )
  }
}

struct SoftProgress_Previews: PreviewProvider {
  
  init() {
    NounsUI.configure()
  }
  
  static var previews: some View {
    SoftProgress(value: 0.7, text: "Preparing video...")
      .padding(.horizontal, 20)
  }
}
