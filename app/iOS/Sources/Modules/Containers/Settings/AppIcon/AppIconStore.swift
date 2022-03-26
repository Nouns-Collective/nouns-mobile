//
//  AppIconCollectionView.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct AppIconStore: View {
  @State private var selectedIcon: AppIcon = AppIcon(previewImage: "Default", appIconAsset: "AppIcon", name: "Default")
  @Environment(\.dismiss) private var dismiss
  private let localize = R.string.appIcon.self
  
  struct AppIcon: Hashable {
    let previewImage: String
    let appIconAsset: String
    let name: String
  }
  
  let icons: [AppIcon] = [
    AppIcon(previewImage: "AppIcon_Preview", appIconAsset: "AppIcon", name: "Default"),
    AppIcon(previewImage: "Bonsai_Preview", appIconAsset: "Bonsai", name: "Bonsai"),
    AppIcon(previewImage: "CannedHam_Preview", appIconAsset: "CannedHam", name: "Canned Ham"),
    AppIcon(previewImage: "Cone_Preview", appIconAsset: "Cone", name: "Cone"),
    AppIcon(previewImage: "Cow_Preview", appIconAsset: "Cow", name: "Cow"),
    AppIcon(previewImage: "Crab_Preview", appIconAsset: "Crab", name: "Crab"),
    AppIcon(previewImage: "Dictionary_Preview", appIconAsset: "Dictionary", name: "Dictionary"),
    AppIcon(previewImage: "DNA_Preview", appIconAsset: "DNA", name: "DNA"),
    AppIcon(previewImage: "Earth_Preview", appIconAsset: "Earth", name: "Earth"),
    AppIcon(previewImage: "Fan_Preview", appIconAsset: "Fan", name: "Fan"),
    AppIcon(previewImage: "Fox_Preview", appIconAsset: "Fox", name: "Fox"),
    AppIcon(previewImage: "Gnome_Preview", appIconAsset: "Gnome", name: "Gnome"),
    AppIcon(previewImage: "HighHeel_Preview", appIconAsset: "HighHeel", name: "HighHeel"),
    AppIcon(previewImage: "Ketchup_Preview", appIconAsset: "Ketchup", name: "Ketchup"),
    AppIcon(previewImage: "Laptop_Preview", appIconAsset: "Laptop", name: "Laptop"),
    AppIcon(previewImage: "Milk_Preview", appIconAsset: "Milk", name: "Milk"),
    AppIcon(previewImage: "Noodles_Preview", appIconAsset: "Noodles", name: "Noodles"),
    AppIcon(previewImage: "Robot_Preview", appIconAsset: "Robot", name: "Robot"),
    AppIcon(previewImage: "Shark_Preview", appIconAsset: "Shark", name: "Shark"),
    AppIcon(previewImage: "Starsparkles_Preview", appIconAsset: "Starsparkles", name: "Starsparkles"),
    AppIcon(previewImage: "Taco_Preview", appIconAsset: "Taco", name: "Taco"),
    AppIcon(previewImage: "UFO_Preview", appIconAsset: "UFO", name: "UFO"),
    AppIcon(previewImage: "Void_Preview", appIconAsset: "Void", name: "Void"),
    AppIcon(previewImage: "Volcano_Preview", appIconAsset: "Volcano", name: "Volcano"),
    AppIcon(previewImage: "Wave_Preview", appIconAsset: "Wave", name: "Wave"),
    AppIcon(previewImage: "Weed_Preview", appIconAsset: "Weed", name: "Weed")
  ]
  
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
  }
}

struct AppIconStore_Previews: PreviewProvider {
  static var previews: some View {
    AppIconStore()
  }
}
