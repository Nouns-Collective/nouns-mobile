//
//  OnChainNounProfileView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

/// Profile view for showing noun details when selected from the explorer view
struct OnChainNounProfileView: View {
  @Binding var isPresented: Bool
  
  @State var isActivityPresented: Bool = false
  
  let noun: String
  let date: String
  let owner: String
    
  var body: some View {
    ZStack {
      WarmGreydient()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
      
      VStack(spacing: 0) {
        Spacer()
        
        NounPuzzle(
          head: Image("head-baseball-gameball", bundle: Bundle.NounAssetBundle),
          body: Image("body-grayscale-9", bundle: Bundle.NounAssetBundle),
          glass: Image("glasses-square-black-rgb", bundle: Bundle.NounAssetBundle),
          accessory: Image("accessory-aardvark", bundle: Bundle.NounAssetBundle)
        )
        
        PlainCell {
          VStack {
            HStack {
              Text("Noun 62")
                .font(Font.custom(.bold, relativeTo: .title2))
              
              Spacer()
              
              SoftButton(image: Image("xmark", bundle: Bundle.SymbolBundle), text: nil) {
                isPresented.toggle()
              }
            }
            
            VStack(alignment: .leading, spacing: 20) {
              Label {
                Text("Born \(date)")
                  .font(Font.custom(.regular, relativeTo: .subheadline))
              } icon: {
                Image("Birthday", bundle: Bundle.SymbolBundle)
              }
              
              Label {
                Text("Won for ")
                  .font(Font.custom(.regular, relativeTo: .subheadline)) +
                Text("135")
                  .bold()
              } icon: {
                Image("Won-price", bundle: Bundle.SymbolBundle)
              }

              Label {
                HStack {
                  Text("Held by ")
                    .font(Font.custom(.regular, relativeTo: .subheadline)) +
                  Text(owner)
                    .font(Font.custom(.bold, relativeTo: .subheadline))
                    .bold()
                  
                  Spacer()
                  
                  Image("Md-Arrow-Right", bundle: Bundle.SymbolBundle)
                }
              } icon: {
                Image("Holder", bundle: Bundle.SymbolBundle)
              }
              
              Label(title: {
                HStack {
                  Text("Activity")
                    .font(Font.custom(.regular, relativeTo: .subheadline))
                  Spacer()
                  Image("Md-Arrow-Right", bundle: Bundle.SymbolBundle)
                }
              }, icon: {
                Image("History", bundle: Bundle.SymbolBundle)
              })
                .contentShape(Rectangle())
                .onTapGesture { isActivityPresented.toggle() }
            }
            .labelStyle(.titleAndIcon(spacing: 14))
            .padding(.bottom, 40)
            
            HStack {
              SoftButton(image: Image("Share", bundle: Bundle.SymbolBundle), text: "Share", action: {
                //
              }, fill: [.width])
              
              SoftButton(image: Image("Splice", bundle: Bundle.SymbolBundle), text: "Remix", action: {
                //
              }, fill: [.width])
            }
          }
        }.padding([.bottom, .horizontal])
      }.sheet(isPresented: $isActivityPresented, onDismiss: nil, content: {
        NounderActivitiesView(isPresented: $isActivityPresented, domain: "bob.eth")
      })
    }
  }
}
