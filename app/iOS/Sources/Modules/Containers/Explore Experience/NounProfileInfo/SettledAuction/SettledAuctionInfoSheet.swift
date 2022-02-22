//
//  SettledAuctionInfoSheet.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import Services
import UIComponents

struct SettledAuctionInfoSheet: View {
  @StateObject var viewModel: ViewModel
  @Binding var isActivityPresented: Bool
  
  @State private var isSafariPresented = false
  
  private var nounOwnerDomain: some View {
    Label {
      HStack(spacing: 4) {
        Text(R.string.nounProfile.heldBy())
          .font(.custom(.regular, relativeTo: .subheadline))
        
        ENSText(token: viewModel.winner)
          .lineLimit(1)
          .font(.custom(.medium, relativeTo: .subheadline))
          .truncationMode(.middle)
      
        Spacer()
        
        Image.mdArrowRight
      }
    } icon: {
      Image.holder
    }
    .contentShape(Rectangle())
    .onTapGesture {
      isActivityPresented.toggle()
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      // The date when the auction was created.
      if viewModel.showBirthdate {
        InfoCell(
          text: viewModel.birthdate,
          icon: { Image.birthday })
      }
      
      // Displays the wining bid amount.
      if viewModel.showWinningBid {
        InfoCell(
          text: R.string.nounProfile.bidWinner(),
          calloutText: viewModel.winningBid,
          icon: { Image.wonPrice },
          calloutIcon: { Image.eth })
      }
      
      // Displays the winner of the auction using `ENS` or `Token`.
      nounOwnerDomain
      
      // Action to display the governance details of the auction.
      InfoCell(
        text: viewModel.governanceTitle,
        icon: { Image.history },
        accessory: { Image.mdArrowRight },
        action: { isActivityPresented.toggle() })
    }
    .labelStyle(.titleAndIcon(spacing: 14))
    .padding(.bottom, 40)
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let url = viewModel.nounProfileURL {
        Safari(url: url)
      }
    }
  }
}
