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
import NounsUI

extension NounCreator {
  
  struct GradientPickerItem: View {
    
    @State private var width: CGFloat = 10
    
    private let colors: [Color]
    
    init(colors: [Color]) {
      self.colors = colors
    }
    
    var body: some View {
      LinearGradient(
        colors: colors,
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(width: width)
        .background(
          GeometryReader { proxy in
            Color.clear
              .onAppear {
                self.width = proxy.size.height
              }
          }
        )
    }
  }
}

private struct GradientSelectedModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(Color.black.opacity(0.05))
      .overlay {
        ZStack {
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.componentNounsBlack, lineWidth: 2)
          Image.checkmark
        }
      }
  }
}

extension NounCreator.GradientPickerItem {
  
  func selected(_ condition: Bool) -> some View {
    if condition {
      return AnyView(modifier(GradientSelectedModifier()))
    } else {
      return AnyView(self)
    }
  }
}
