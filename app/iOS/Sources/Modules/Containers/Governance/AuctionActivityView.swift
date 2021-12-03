//
//  AuctionActivityView.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI
import UIComponents
import Services

struct AuctionActivityView: View {
  let auction: Auction
  @Binding var isPresented: Bool
  
  @EnvironmentObject private var store: AppStore
  @Namespace private var pickerNamespace
  @State private var tabSelection = 0
  @State private var isGovernanceInfoPresented = false
  
  var body: some View {
    PickerTabView(animation: pickerNamespace, selection: $tabSelection) {
      
      ProfileActivityFeed(auction: auction)
        .pickerTabItem(R.string.activity.menuTitle(), tag: 0)
      
      ProfileBidHistory(auction: auction)
        .pickerTabItem(R.string.bidHistory.menuTitle(), tag: 1)
    }
    // TODO: NavigationBar should support the translucent mode.
    .offset(y: -44)
    .padding(.bottom, -40)
    .softNavigationItems(leftAccessory: {
      // Dismisses Nounder Activities & Bids History
      SoftButton(
        icon: { Image.back },
        action: { isPresented.toggle() })
      
    }, rightAccessory: {
      SoftButton(
        icon: { Image.help },
        action: { isGovernanceInfoPresented.toggle() })
    })
    .ignoresSafeArea(.all, edges: .bottom)
    .background(Gradient.warmGreydient)
    .bottomSheet(isPresented: $isGovernanceInfoPresented) {
      GovernanceInfoView(isPresented: $isGovernanceInfoPresented)
    }
  }
}
