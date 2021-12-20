//
//  AuctionActivityView.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI
import UIComponents

struct AuctionInfoContainer: View {
  @StateObject var viewModel: ViewModel
  
  @Namespace private var pickerNamespace
  @State private var selectedPage: Int
  @State private var isGovernanceInfoPresented = false
  @Environment(\.dismiss) private var dismiss
  
  init(viewModel: ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedPage = State(initialValue: viewModel.initialVisiblePage.rawValue)
  }
  
  var body: some View {
    PickerTabView(animation: pickerNamespace, selection: $selectedPage) {
      
      if viewModel.isActivityAvailable {
        NounActivityFeed(viewModel: .init(auction: viewModel.auction))
          .pickerTabItem(
            R.string.activity.menuTitle(),
            tag: Page.activity.rawValue
          )
      }
      
      AuctionBidHistory(viewModel: .init(auction: viewModel.auction))
        .pickerTabItem(
          R.string.bidHistory.menuTitle(),
          tag: Page.bidHitory.rawValue
        )
    }
    // TODO: NavigationBar should support the translucent mode.
    .offset(y: -44)
    .padding(.bottom, -40)
    .softNavigationItems(leftAccessory: {
      // Dismisses Noun's Activity & Bids History
      SoftButton(
        icon: { Image.back },
        action: { dismiss() })
      
    }, rightAccessory: {
      SoftButton(
        icon: { Image.help },
        action: {
          withAnimation {
            isGovernanceInfoPresented.toggle()
          }
        })
    })
    .ignoresSafeArea(.all, edges: .bottom)
    .background(Gradient.warmGreydient)
    .bottomSheet(isPresented: $isGovernanceInfoPresented) {
      GovernanceInfoCard(isPresented: $isGovernanceInfoPresented)
    }
  }
}
