//
//  OnChainNounProfileView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Profile view for showing noun details when selected from the explorer view
struct AuctionInfoView: View {
  let auction: Auction
  
  @EnvironmentObject private var store: AppStore
  @Environment(\.presentationMode) private var presentationMode
  @State private var isActivityPresented = false
  @State private var showShareSheet = false
  
  private var noun: Noun {
    auction.noun
  }
  
  private var detailRows: some View {
    switch auction.settled {
    case true:
      return AnyView(SettledAuctionDetailRows(
        isActivityPresented: $isActivityPresented,
        auction: auction
      ))
      
    case false:
      return AnyView(LiveAuctionDetailDialog(
        auction: auction,
        isActivityPresented: $isActivityPresented))
    }
  }
  
  private var nounIDLabel: some View {
    Text(R.string.explore.noun(noun.id))
      .font(.custom(.bold, relativeTo: .title2))
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        
        NavigationLink(isActive: $isActivityPresented) {
          NounderView(
            isPresented: $isActivityPresented,
            noun: noun)
        } label: {
          EmptyView()
        }
        
        NounPuzzle(seed: noun.seed)
        
        PlainCell {
          VStack {
            HStack {
              nounIDLabel
              Spacer()
              
              SoftButton(icon: { Image.xmark }, action: {
                presentationMode.wrappedValue.dismiss()
              })
            }
            
            detailRows
              .labelStyle(.titleAndIcon(spacing: 14))
              .padding(.bottom, 40)
            
            HStack {
              SoftButton(
                text: R.string.shared.share(),
                largeAccessory: { Image.share },
                action: {showShareSheet.toggle() },
                fill: [.width])
              
              SoftButton(
                text: R.string.shared.remix(),
                largeAccessory: { Image.splice },
                action: { },
                fill: [.width])
            }
            
          }.padding()
        }
        .padding([.bottom, .horizontal])
      }
      .background(Gradient.warmGreydient)
    }
    .sheet(isPresented: $showShareSheet) {
      if let url = URL(string: "https://nouns.wtf/noun/\(noun.id)") {
        ShareSheet(activityItems: [url])
      }
    }
  }
}
