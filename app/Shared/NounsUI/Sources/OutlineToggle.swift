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

public struct OutlineToggle: View {
  @Binding public var isOn: Bool
  @Namespace private var toggleNamespace
  
  public init(isOn: Binding<Bool>) {
    self._isOn = isOn
  }
  
  public var body: some View {
    ZStack(alignment: isOn ? .trailing : .leading) {
      Capsule()
        .strokeBorder(.black, lineWidth: 2)
        .background(isOn ? AnyView(Gradient.lemonDrop) : AnyView(Color.white))
        .clipShape(Capsule())
        .frame(width: 56, height: 34)
      
      HStack {
        if isOn {
          Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(.white)
            .clipShape(Circle())
            .frame(width: 27, height: 27)
            .padding(.trailing, 3)
            .matchedGeometryEffect(id: "toggle", in: toggleNamespace)
        } else {
          Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(.white)
            .clipShape(Circle())
            .frame(width: 27, height: 27)
            .padding(.leading, 3)
            .matchedGeometryEffect(id: "toggle", in: toggleNamespace)
        }
      }
    }
    .onTapGesture {
      withAnimation(.easeIn(duration: 0.05)) {
        isOn.toggle()
      }
    }
  }
}

struct OutlineToggle_Previews: PreviewProvider {
  static var previews: some View {
    OutlineToggle(isOn: .constant(false))
      .previewLayout(.sizeThatFits)
  }
}
