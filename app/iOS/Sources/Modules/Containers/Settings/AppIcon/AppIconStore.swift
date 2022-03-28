//
//  AppIconCollectionView.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct AppIconStore: View {
  @State private var selectedIcon: String? = UIApplication.shared.alternateIconName
  @Environment(\.dismiss) private var dismiss
  private let localize = R.string.appIcon.self
  
  struct AppIcon: Hashable, Decodable {
    let preview: String
    let asset: String?
    let name: String
  }
  
  struct AppIconLibrary: Hashable, Decodable {
    let regular: [AppIcon]
    let neon: [AppIcon]
  }
  
  @State private var icons: [AppIcon] = []
  
  private let columnsSpec = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
  ]
  
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
      // Do any additional setup after loading the view.
      let url = Bundle.main.url(forResource: "AppIcons", withExtension: "plist")!
      do {
        let data = try Data(contentsOf: url)
        let result = try PropertyListDecoder().decode(AppIconLibrary.self, from: data)
        print("Result: \(result)")
        self.icons = result.regular + result.neon
      } catch { print("Error: \(error)") }
    }
  }
}

struct AppIconStore_Previews: PreviewProvider {
  static var previews: some View {
    AppIconStore()
  }
}
