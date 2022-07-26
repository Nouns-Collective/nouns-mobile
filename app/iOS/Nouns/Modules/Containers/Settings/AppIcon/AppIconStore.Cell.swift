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
import os

extension AppIconStore {
  
  struct Cell: View {
    @StateObject var viewModel = ViewModel()

    let icon: AppIcon
    @Binding var selection: String?
    
    @Environment(\.nounComposer) private var nounComposer
    
    @State private var cellWidth: CGFloat = 80
    
    private var backgroundFillColor: Color {
      isSelected ? .componentNounsBlack.opacity(0.3) : .white
    }
    
    private var textColor: Color {
      isSelected ? .white : .componentNounsBlack
    }
    
    private var isSelected: Bool {
      selection == icon.asset
    }
    
    /// An object for writing interpolated string messages to the unified logging system.
    private let logger = Logger(
      subsystem: "wtf.nouns.ios",
      category: "Nouns App Icon Store"
    )
    
    var body: some View {
      VStack(spacing: 10) {
        Image(icon.preview)
          .resizable()
          .frame(width: cellWidth * 0.6, height: cellWidth * 0.6, alignment: .center)
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.gray)
          .cornerRadius(15.6)
          
        HStack {
          Text(icon.name)
            .font(.custom(.medium, relativeTo: .caption))
            .foregroundColor(textColor)
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 20)
      .border(.black, lineWidth: 3, fillColor: backgroundFillColor, cornerRadius: 8)
      .onTapGesture {
        UIApplication.shared.setAlternateIconName(icon.asset) { error in
          viewModel.onAppIconChanged(icon, error: error)

          if let error = error {
            logger.error("Error setting alternate icon for asset for asset \"\(icon.asset ?? "unknown")\": \(error.localizedDescription, privacy: .public)")
            return
          }

          withAnimation {
            selection = icon.asset
          }
        }
      }
      .background(
        GeometryReader { proxy in
          Color.clear
            .onAppear {
              // Store the cell width to base the icon preview size on
              self.cellWidth = proxy.size.width
            }
        }
      )
    }
  }
}
