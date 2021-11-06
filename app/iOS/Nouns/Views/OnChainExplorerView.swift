//
//  OnChainExplorerView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Combine

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
func onChainExplorerReducer(state: inout OnChainExplorerState, action: OnChainExplorerAction) {
  switch action {
//  case .liveAuctionAction(let action):
//    liveAuctionReducer(state: &state.liveAuctionState, action: action)
  case .onChainNounsAction(let action):
    onChainNounsReducer(state: &state.onChainNounState, action: action)
  }
}

/// <#Description#>
struct OnChainExplorerState {
  //var activityIndicatorState: ActivityIndicatorState
  var onChainNounState: OnChainNounsState
  //var liveAuctionState: LiveAuctionState
}

/// <#Description#>
enum OnChainExplorerAction {
//  case liveAuctionAction(action: LiveAuctionAction)
  case onChainNounsAction(action: OnChainNounsAction)
}

/// Housing view for exploring on chain nouns, including the current on-goign auction and previously auctioned nouns
struct OnChainExplorerView: View {
  @Namespace private var animation
  @State var selected: Int?
  
  @State var isPresentingActivity: Bool = false
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      ScrollViewReader { proxy in
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 40) {
            LiveAuctionCard(noun: "Noun 64")
              .padding(.horizontal, -20)
            
            OnChainNounsView(
              animation: animation,
              selected: $selected,
              isPresentingActivity: $isPresentingActivity
            )
          }
        }
        .ignoresSafeArea()
        .onChange(of: selected) { newValue in
          if let newValue = newValue {
            withAnimation {
              proxy.scrollTo(newValue, anchor: .top)
            }
          }
        }
      }
      
      if selected != nil {
        PilledButton(systemImage: "xmark", action: {
          withAnimation(.spring()) {
            self.selected = nil
          }
        }, appearance: .light).padding(.trailing, 20)
      }
    }.bottomSheet(isPresented: $isPresentingActivity) {
      NounderActivitiesSheet(isPresented: $isPresentingActivity)
        .padding(.bottom, 40)
    }
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
