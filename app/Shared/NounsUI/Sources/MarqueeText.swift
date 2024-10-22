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

public struct MarqueeText: View {
  
  private let text: String
  private let alignment: Alignment
  private let font: UIFont
  
  public init(text: String, alignment: Alignment, font: UIFont = UIFont.custom(.bold, size: 10)) {
    self.text = text
    self.alignment = alignment
    self.font = font
  }
  
  @State private var animate = false
  
  public var body: some View {
    let stringWidth = text.widthOfString(usingFont: font)
    let stringHeight = text.heightOfString(usingFont: font)
    
    let animation = Animation
      .linear(duration: Double(stringWidth) / 30)
      .repeatForever(autoreverses: false)
    
    return ZStack {
      GeometryReader { proxy in
        if stringWidth > proxy.size.width {
          Group {
            Text(self.text)
              .lineLimit(1)
              .font(.init(font))
              .offset(x: self.animate ? -stringWidth : 0)
              .animation(self.animate ? animation : nil, value: self.animate)
              .onAppear {
                Task.init {
                  self.animate = proxy.size.width < stringWidth
                }
              }
              .fixedSize(horizontal: true, vertical: false)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            
            Text(self.text)
              .lineLimit(1)
              .font(.init(font))
              .offset(x: self.animate ? 0 : stringWidth)
              .animation(self.animate ? animation : nil, value: self.animate)
              .onAppear {
                Task.init {
                  self.animate = proxy.size.width < stringWidth
                }
              }
              .fixedSize(horizontal: true, vertical: false)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
          }
          .onChange(of: self.text, perform: { _ in
            self.animate = proxy.size.width < stringWidth
          })
          .frame(width: proxy.size.width)
        } else {
          Text(self.text)
            .font(.init(font))
            .onChange(of: self.text, perform: { _ in
              self.animate = proxy.size.width < stringWidth
            })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
        }
      }
    }
    .frame(height: stringHeight)
  }
}

extension String {
  
  func widthOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
  
  func heightOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.height
  }
}
