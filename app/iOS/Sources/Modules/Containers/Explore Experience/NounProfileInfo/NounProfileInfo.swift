//
//  NounProfileView.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import UIComponents
import Services
import SpriteKit

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
  
  /// The background gradient colors of the noun, based on the seed's `background` value
  private var background: GradientColors {
    viewModel.nounTraits.background == 0 ? .coolGreydient : .warmGreydient
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
  
  /// A view that displays an animated noun.
  ///
  /// - Returns: This view contains the play scene to animate the Noun's eyes.
  private let talkingNoun: TalkingNoun
  
  @State private var width: CGFloat = 100 
  
  public init(viewModel: ViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    talkingNoun = TalkingNoun(seed: viewModel.auction.noun.seed)
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        
        if !viewModel.isAuctionSettled {
          SpriteView(scene: talkingNoun, options: [.allowsTransparency])
            .background(
              GeometryReader { proxy in
                Color.clear
                  .onAppear {
                    self.width = proxy.size.width
                  }
              }
            )
            .frame(
              minWidth: 100,
              idealWidth: self.width,
              maxWidth: .infinity,
              minHeight: 100,
              idealHeight: self.width,
              maxHeight: .infinity,
              alignment: .center
            )
        } else {
          NounPuzzle(seed: viewModel.nounTraits)
        }
        
        PlainCell(length: 20) {
          if !viewModel.isAuctionSettled {
            MarqueeText(text: LiveAuctionCard.liveAuctionMarqueeString, alignment: .center)
              .padding(.vertical, 5)
              .border(width: 2, edges: [.bottom], color: .componentNounsBlack)
              .padding([.top, .horizontal], -20)
          }

          toolbarContent
          
          if viewModel.isAuctionSettled || viewModel.isWinnerAnnounced {
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
      .background(Gradient(background, startPoint: .center, endPoint: .bottom))
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = viewModel.nounProfileURL {
        let message = R.string.nounProfile.shareMessage(viewModel.auction.noun.id)
        ShareSheet(activityItems: [],
                   titleMetadata: message,
                   urlMetadata: url)
      }
    }
    .fullScreenCover(isPresented: $viewModel.shouldShowNounCreator) {
      NounCreator(viewModel: .init(initialSeed: viewModel.nounTraits))
    }
    .notificationPermissionDialog(isPresented: $viewModel.isNotificationPermissionDialogPresented)
    .addBottomSheet()
    .onAppear(perform: viewModel.onAppear)
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
