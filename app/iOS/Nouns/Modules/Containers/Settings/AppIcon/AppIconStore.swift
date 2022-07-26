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

struct AppIconStore: View {
  @StateObject var viewModel = ViewModel()

  @State private var selectedIcon: String? = UIApplication.shared.alternateIconName
  @Environment(\.dismiss) private var dismiss
  private let localize = R.string.appIcon.self
  
  struct AppIconLibrary: Hashable, Decodable {
    let regular: [AppIcon]
  }
  
  struct AppIcon: Hashable, Decodable {
    let preview: String
    let asset: String?
    let name: String
  }
  
  @State private var icons: [AppIcon] = []
  
  private let columnsSpec = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
  ]
  
  /// An object for writing interpolated string messages to the unified logging system.
  private let logger = Logger(
    subsystem: "wtf.nouns.ios",
    category: "Nouns App Icon Store"
  )
  
  private func loadAppIcons() {
    guard let url = Bundle.main.url(forResource: "AppIcons", withExtension: "plist") else { return }
    
    do {
      let data = try Data(contentsOf: url)
      let result = try PropertyListDecoder().decode(AppIconLibrary.self, from: data)
      self.icons = result.regular
    } catch {
      logger.error("Failed to load app icon library from plist file")
    }
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVGrid(columns: columnsSpec, spacing: 16) {
        ForEach(icons, id: \.self) { icon in
          Cell(icon: icon, selection: $selectedIcon)
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 20)
      .softNavigationTitle(localize.title(), leftAccessory: {
        // Pops view from the navigation stack.
        SoftButton(
          icon: { Image.back },
          action: { dismiss() })
      })
      .padding(.top, 50)
    }
    .background(Gradient.lemonDrop)
    .overlay(.componentUnripeLemon, edge: .top)
    .ignoresSafeArea(edges: .top)
    .onAppear {
      viewModel.onAppear()

      // Do any additional setup after loading the view.
      loadAppIcons()
    }
  }
}

struct AppIconStore_Previews: PreviewProvider {
  static var previews: some View {
    AppIconStore()
  }
}
