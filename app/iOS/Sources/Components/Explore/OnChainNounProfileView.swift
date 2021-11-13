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
  
  private var nounIDLabel: some View {
    Text("Noun 62")
      .font(.custom(.bold, relativeTo: .title2))
  }
  
  private var birthdateRow: some View {
    Label {
      Text("Born \(date)")
        .font(.custom(.regular, relativeTo: .subheadline))
    } icon: {
      Image.birthday
    }
  }
  
  private var bidWinnerRow: some View {
    Label {
      Text("Won for ")
        .font(.custom(.regular, relativeTo: .subheadline)) +
      Text("135")
        .bold()
      
    } icon: {
      Image.wonPrice
    }
  }
  
  private var ownerRow: some View {
    Label {
      HStack {
        Text("Held by ")
          .font(.custom(.regular, relativeTo: .subheadline))
        +
        Text(owner)
          .font(.custom(.bold, relativeTo: .subheadline))
          .bold()
        
        Spacer()
        
        Image.mdArrowRight
      }
    } icon: {
      Image.holder
    }
  }
  
  private var activityRow: some View {
    Label(title: {
      HStack {
        Text("Activity")
          .font(Font.custom(.regular, relativeTo: .subheadline))
        Spacer()
        Image.mdArrowRight
      }
    }, icon: {
      Image.history
    })
  }
  
  private var actionsRow: some View {
    HStack {
      SoftButton(
        image: Image.share,
        text: "Share",
        action: { },
        fill: [.width])
      
      SoftButton(
        image: Image.splice,
        text: "Remix",
        action: { },
        fill: [.width])
    }
  }
  
  var body: some View {
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
            nounIDLabel
            Spacer()
            SoftButton(image: Image.xmark, text: nil) {
              isPresented.toggle()
            }
          }
          
          VStack(alignment: .leading, spacing: 20) {
            birthdateRow
            bidWinnerRow
            ownerRow
            
            activityRow
              .contentShape(Rectangle())
              .onTapGesture { isActivityPresented.toggle() }
          }
          .labelStyle(.titleAndIcon(spacing: 14))
          .padding(.bottom, 40)
          
          actionsRow
        }
      }
      .padding([.bottom, .horizontal])
    }
    .background(Gradient.warmGreydient)
    .sheet(isPresented: $isActivityPresented, onDismiss: nil) {
      
      NounderActivitiesView(
        isPresented: $isActivityPresented,
        domain: "bob.eth")
    }
  }
}
