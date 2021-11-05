//
//  OnChainNounProfileCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

/// Card showing a noun with more details, including the ETH address of the owner, the date it was born, and a segue to look at a noun's activity.
struct OnChainNounProfileCard: View {
  var animation: Namespace.ID
  
  let noun: String
  let date: String
  let owner: String
  let status: String = "Winner"
  var topPadding: CGFloat = 20
  
  @Binding var isShowingActivity: Bool
  
  var body: some View {
    StandardCard {
        NounPuzzle(
          head: Image("head-baseball-gameball", bundle: Bundle.NounAssetBundle),
          body: Image("body-grayscale-9", bundle: Bundle.NounAssetBundle),
          glass: Image("glasses-square-black-rgb", bundle: Bundle.NounAssetBundle),
          accessory: Image("accessory-aardvark", bundle: Bundle.NounAssetBundle)
        )
        .matchedGeometryEffect(id: "\(noun)-puzzle", in: animation)
        .padding(.top, topPadding)
    } label: {
      VStack {
        HStack(alignment: .center) {
          Text(noun)
            .font(.title)
            .fontWeight(.semibold)
          
          Spacer()
          
          Image(systemName: "rectangle.portrait.and.arrow.right")
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Label("ETH Address", systemImage: "cpu")
          Label("Born on Oct 11 2021", systemImage: "gift")
          Label {
            HStack {
              Text("Taken care of by")
              Button {
                isShowingActivity.toggle()
              } label: {
                Text("bobby.eth")
                  .foregroundColor(Color.componentRaspberry)
              }
            }
          } icon: {
            Image(systemName: "suit.heart")
          }

        }.labelStyle(.titleAndIcon(spacing: 20))
          .padding(.top, 8)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
          PilledButton(systemImage: "square.and.arrow.up", text: "Share", action: {
            //
          }, appearance: .custom(color: Color.componentSoftGrey), fill: [.width])

          PilledButton(systemImage: "shuffle", text: "Remix", action: {
            //
          }, appearance: .custom(color: Color.componentSoftGrey), fill: [.width])
        }.padding(.top, 20)
      }
    }
  }
}
