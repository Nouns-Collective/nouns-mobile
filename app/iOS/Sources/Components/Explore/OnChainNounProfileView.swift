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
struct OnChainNounProfileView: View {
  @Binding var isPresented: Bool
  @State var isActivityPresented: Bool = false
  
  let noun: Noun
  
  private var nounIDLabel: some View {
    Text("Noun \(noun.id)")
      .font(.custom(.bold, relativeTo: .title2))
  }
  
  private var birthdateRow: some View {
    Label {
      Text("Born Oct 11 1961")
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
        Text("bob.eth")
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
        text: "Share",
        largeAccessory: {
          Image.share
        },
        action: { },
        fill: [.width])
      
      SoftButton(
        text: "Remix",
        largeAccessory: {
          Image.splice
        },
        action: { },
        fill: [.width])
    }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      NounPuzzle(
        head: AppCore.shared.nounComposer.heads[noun.seed.head].data,
        body: AppCore.shared.nounComposer.bodies[noun.seed.body].data,
        glass: AppCore.shared.nounComposer.glasses[noun.seed.glasses].data,
        accessory: AppCore.shared.nounComposer.accessories[noun.seed.accessory].data
      )
      
      PlainCell {
        VStack {
          HStack {
            nounIDLabel
            Spacer()
            
            SoftButton(icon: {
              Image.xmark
            }, action: {
              isPresented.toggle()
            })
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
        noun: noun)
    }
  }
}
