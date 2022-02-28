//
//  AppIconCollectionView.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct AppIconStore: View {
  @State private var selectedIcon = 0
  @Environment(\.nounComposer) private var nounComposer
  @Environment(\.dismiss) private var dismiss
  private let localize = R.string.appIcon.self
  
  private let columnsSpec = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVGrid(columns: columnsSpec) {
        ForEach(nounComposer.heads.indices, id: \.self) { index in
          Cell(index: index, selection: $selectedIcon)
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
    }
    .background(Gradient.lemonDrop)
  }
}

struct AppIconStore_Previews: PreviewProvider {
  static var previews: some View {
    AppIconStore()
  }
}
