//
//  CreateView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

struct CreateView: View {
  @Environment(\.managedObjectContext) var context
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.create.subhealine())
          .font(.custom(.regular, size: 17))
        
        NounPuzzle(
          head: Image(nounTraitName: AppCore.shared.nounComposer.heads[3].assetImage),
          body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[6].assetImage),
          glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[0].assetImage),
          accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[0].assetImage))
          .padding(.top, 40)
        
        OutlineButton(
          text: R.string.create.proceedTitle(),
          largeAccessory: { Image.fingergunsRight },
          action: { },
          fill: [.width])
        
        Spacer()
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 20)
      .softNavigationTitle(R.string.create.title())
      .background(Gradient.freshMint)
      .ignoresSafeArea()
    }
  }
}

struct CreateView_Previews: PreviewProvider {
  static var previews: some View {
    CreateView()
  }
}
