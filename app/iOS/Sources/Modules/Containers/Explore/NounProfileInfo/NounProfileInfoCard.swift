//
//  NounProfileInfoCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import UIComponents
import Services

struct NounProfileInfoCard: View {
  @StateObject var viewModel: ViewModel
  
  @State private var isActivityPresented = false
  @State private var isShareSheetPresented = false
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        NounPuzzle(seed: viewModel.auction.noun.seed)
        
        PlainCell(length: 20) {
          CardToolBar(viewModel: viewModel, dismiss: dismiss)
          
          if viewModel.isAuctionSettled {
            SettledAuctionInfoCard(
              viewModel: .init(auction: viewModel.auction),
              isActivityPresented: $isActivityPresented
            )
            
          } else {
            LiveAuctionInfoCard(
              viewModel: .init(auction: viewModel.auction),
              isActivityPresented: $isActivityPresented
            )
          }
          
          // Navigation link showing the noun's bid history & owner activity
          // TODO: - Build a component to hide the navigation implementation details.
          NavigationLink(
            destination: AuctionInfoContainer(viewModel: .init(auction: viewModel.auction)),
            isActive: $isActivityPresented) { EmptyView() }
          
          CardActionsItems(
            isShareSheetPresented: $isShareSheetPresented
          )
        }
        .padding([.bottom, .horizontal])
      }
      .background(Gradient.warmGreydient)
    }
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = viewModel.nounProfileURL {
        ShareSheet(activityItems: [url])
      }
    }
  }
}

extension NounProfileInfoCard {
  
  struct CardToolBar: View {
    @ObservedObject var viewModel: ViewModel
    let dismiss: DismissAction
    
    var body: some View {
      HStack {
        Text(viewModel.title)
          .font(.custom(.bold, relativeTo: .title2))
        
        Spacer()
        
        SoftButton(
          icon: { Image.xmark },
          action: { dismiss() })
      }
    }
  }
}

extension NounProfileInfoCard {
  
  struct CardActionsItems: View {
    @Binding var isShareSheetPresented: Bool
    
    var body: some View {
      // Various available actions.
      HStack {
        // Shares the live auction link.
        SoftButton(
          text: R.string.shared.share(),
          largeAccessory: { Image.share },
          action: { isShareSheetPresented.toggle() })
          .controlSize(.large)
        
        // Switch context to the creator exprience using the current Noun's seed.
        SoftButton(
          text: R.string.shared.remix(),
          largeAccessory: { Image.splice },
          action: { })
          .controlSize(.large)
      }
    }
  }
}
