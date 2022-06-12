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

struct AuctionInfo: View {
  @StateObject var viewModel: ViewModel
  
  @Namespace private var pickerNamespace
  @State private var selectedPage: Page
  @State private var isGovernanceInfoPresented = false
  @Environment(\.dismiss) private var dismiss
  
  init(viewModel: ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedPage = State(initialValue: viewModel.initialVisiblePage)
  }
  
  var body: some View {
    // TODO: - Delete once PickerTabView accepts hashable.
    let selection = Binding(
      get: { selectedPage.rawValue },
      set: { selectedPage = Page(rawValue: $0) ?? .activity }
    )
    
    return PickerTabView(animation: pickerNamespace, selection: selection) {
      
      if viewModel.isActivityAvailable {
        NounActivityFeed(viewModel: .init(auction: viewModel.auction))
          .pickerTabItem(
            R.string.activity.menuTitle(),
            tag: Page.activity.rawValue
          )
      }
      
      if viewModel.isBidHistoryAvailable {
        AuctionBidHistory(viewModel: .init(auction: viewModel.auction))
          .pickerTabItem(
            R.string.bidHistory.menuTitle(),
            tag: Page.bidHitory.rawValue
          )
      }
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
      GovernanceInfoCard(
        isPresented: $isGovernanceInfoPresented,
        nounId: viewModel.auction.noun.id,
        owner: viewModel.auction.bidder?.id,
        page: selectedPage
      )
    }
    .onAppear(perform: viewModel.onAppear)
  }
}
