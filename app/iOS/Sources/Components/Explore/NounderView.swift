//
//  NounderView.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounderView: View {
  @EnvironmentObject var store: AppStore
  @State private var selectedTab = 0
  @Binding var isPresented: Bool
  
  let noun: Noun
  
  var body: some View {
    PickerTabView(selection: $selectedTab) {
      
      NounderActivitiesView(noun: noun)
        .pickerTabItem("Activties", tag: 0)
      
      NounderBidsHistoryView()
        .pickerTabItem("Bid history", tag: 1)
    }
    // TODO: NavigationBar should support the translucent mode.
    .offset(y: -40)
    .softNavigationItems(leftAccessory: {
      // Dismisses Nounder Activities & Bids History
      SoftButton(
        icon: { Image.back },
        action: { isPresented.toggle() })
      
    }, rightAccessory: {
      SoftButton(
        icon: { Image.help },
        action: { })
    })
    .background(Gradient.warmGreydient)
  }
}
