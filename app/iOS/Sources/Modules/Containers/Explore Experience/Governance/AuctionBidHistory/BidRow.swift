//
//  BidRow.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import SwiftUI
import UIComponents
import Services

struct BidRow: View {
  let viewModel: ViewModel
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .center) {
          // Bid amount
          Label {
            Text(viewModel.bidAmount)
              .foregroundColor(Color.componentNounsBlack)
              .font(.custom(.bold, size: 24))
          } icon: {
            Image.eth
              .asThumbnail(maxWidth: 18, maxHeight: 18)
          }
          .labelStyle(.titleAndIcon(spacing: 4))
          
          Spacer()
          
          // Timestamp of the bid
          Text(viewModel.bidDate)
            .font(Font.custom(.medium, size: 13))
            .opacity(0.5)
        }
        
        // An Account is any address that holds any amount of Nouns
        Label {
          ENSText(token: viewModel.bidderIdentifier)
            .font(.custom(.medium, size: 17))
            .foregroundColor(Color.componentNounsBlack)
          
        } icon: {
          // Token avatar
          Image(R.image.placeholderEns.name)
            .asThumbnail()
            .clipShape(Circle())
        }
        
      }.padding()
    }
  }
}
