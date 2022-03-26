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
    let appIconAsset: String?
    let name: String
  }
  
  let icons: [AppIcon] = [
    AppIcon(previewImage: "AppIcon_Preview", appIconAsset: nil, name: "Default"),
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
    AppIcon(previewImage: "Weed_Preview", appIconAsset: "Weed", name: "Weed"),
    AppIcon(previewImage: "BonsaiNeon_Preview", appIconAsset: "BonsaiNeon", name: "Bonsai (Neon)"),
    AppIcon(previewImage: "CannedHamNeon_Preview", appIconAsset: "CannedHamNeon", name: "Canned Ham (Neon)"),
    AppIcon(previewImage: "ConeNeon_Preview", appIconAsset: "ConeNeon", name: "Cone (Neon)"),
    AppIcon(previewImage: "CowNeon_Preview", appIconAsset: "CowNeon", name: "Cow (Neon)"),
    AppIcon(previewImage: "CrabNeon_Preview", appIconAsset: "CrabNeon", name: "Crab (Neon)"),
    AppIcon(previewImage: "DictionaryNeon_Preview", appIconAsset: "DictionaryNeon", name: "Dictionary (Neon)"),
    AppIcon(previewImage: "DNANeon_Preview", appIconAsset: "DNANeon", name: "DNA (Neon)"),
    AppIcon(previewImage: "EarthNeon_Preview", appIconAsset: "EarthNeon", name: "Earth (Neon)"),
    AppIcon(previewImage: "FanNeon_Preview", appIconAsset: "FanNeon", name: "Fan (Neon)"),
    AppIcon(previewImage: "FoxNeon_Preview", appIconAsset: "FoxNeon", name: "Fox (Neon)"),
    AppIcon(previewImage: "GnomeNeon_Preview", appIconAsset: "GnomeNeon", name: "Gnome (Neon)"),
    AppIcon(previewImage: "HighHeelNeon_Preview", appIconAsset: "HighHeelNeon", name: "HighHeel (Neon)"),
    AppIcon(previewImage: "KetchupNeon_Preview", appIconAsset: "KetchupNeon", name: "Ketchup (Neon)"),
    AppIcon(previewImage: "LaptopNeon_Preview", appIconAsset: "LaptopNeon", name: "Laptop (Neon)"),
    AppIcon(previewImage: "MilkNeon_Preview", appIconAsset: "MilkNeon", name: "Milk (Neon)"),
    AppIcon(previewImage: "NoodlesNeon_Preview", appIconAsset: "NoodlesNeon", name: "Noodles (Neon)"),
    AppIcon(previewImage: "RobotNeon_Preview", appIconAsset: "RobotNeon", name: "Robot (Neon)"),
    AppIcon(previewImage: "SharkNeon_Preview", appIconAsset: "SharkNeon", name: "Shark (Neon)"),
    AppIcon(previewImage: "StarSparklesNeon_Preview", appIconAsset: "StarsparklesNeon", name: "Starsparkles (Neon)"),
    AppIcon(previewImage: "TacoNeon_Preview", appIconAsset: "TacoNeon", name: "Taco (Neon)"),
    AppIcon(previewImage: "UFONeon_Preview", appIconAsset: "UFONeon", name: "UFO (Neon)"),
    AppIcon(previewImage: "VoidNeon_Preview", appIconAsset: "VoidNeon", name: "Void (Neon)"),
    AppIcon(previewImage: "VolcanoNeon_Preview", appIconAsset: "VolcanoNeon", name: "Volcano (Neon)"),
    AppIcon(previewImage: "WaveNeon_Preview", appIconAsset: "WaveNeon", name: "Wave (Neon)"),
    AppIcon(previewImage: "WeedNeon_Preview", appIconAsset: "WeedNeon", name: "Weed (Neon)")
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
