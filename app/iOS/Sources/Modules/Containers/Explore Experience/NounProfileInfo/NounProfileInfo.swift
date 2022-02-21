//
//  NounProfileView.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import UIComponents
import Services

struct NounProfileInfo: View {
  @StateObject var viewModel: ViewModel
  
  @State private var isActivityPresented = false
  @State private var isShareSheetPresented = false
  @Environment(\.dismiss) private var dismiss
  
  /// A view that displays the toolbar content above the noun info list.
  ///
  /// - Returns: This view contains the title, and a button for dismissing the view.
  var toolbarContent: some View {
    HStack {
      Text(viewModel.title)
        .font(.custom(.bold, relativeTo: .title2))
      
      Spacer()
      
      SoftButton(
        icon: { Image.xmark },
        action: { dismiss() })
    }
  }
  
  /// A view that displays the actions content below the noun info list.
  ///
  /// - Returns: This view contains buttons to `Share` & `Remix` the displayed noun.
  private var actionsContent: some View {
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
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        NounPuzzle(seed: viewModel.nounTraits)
        
        PlainCell(length: 20) {
          toolbarContent
          
          if viewModel.isAuctionSettled || viewModel.isWinnerAnounced {
            SettledAuctionInfoSheet(
              viewModel: .init(auction: viewModel.auction),
              isActivityPresented: $isActivityPresented
            )
          } else {
            LiveAuctionInfoSheet(
              viewModel: .init(auction: viewModel.auction),
              isActivityPresented: $isActivityPresented
            )
          }
          
          // Navigation link showing the noun's bid history & owner activity.
          Link(isActive: $isActivityPresented, content: {
            CardActionsItems(viewModel: viewModel, isShareSheetPresented: $isShareSheetPresented)
            
          }, destination: {
            AuctionInfo(viewModel: .init(auction: viewModel.auction))
          })
          
        }
        .padding([.bottom, .horizontal])
      }
      .background(Gradient.warmGreydient)
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = viewModel.nounProfileURL {
        ShareSheet(activityItems: [url])
      }
    }
    .fullScreenCover(isPresented: $viewModel.shouldShowNounCreator) {
      NounCreator(viewModel: .init(initialSeed: viewModel.nounTraits))
    }
    .addBottomSheet()
  }
}

extension NounProfileInfo {
  
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

extension NounProfileInfo {
  
  struct CardActionsItems: View {
    
    @ObservedObject var viewModel: ViewModel
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
          action: {
            viewModel.shouldShowNounCreator.toggle()
          })
          .controlSize(.large)
      }
    }
  }
}
