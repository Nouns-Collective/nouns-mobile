//
//  NounderView.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounderView: View {
  @EnvironmentObject private var store: AppStore
  @State private var selectedTab = 0
  @State private var isInfoPresented = false
  @Binding var isPresented: Bool
  
  let noun: Noun
  
  var body: some View {
    PickerTabView(selection: $selectedTab) {
      
      NounderActivitiesView(noun: noun)
        .pickerTabItem(R.string.activity.menuTitle(), tag: 0)
      
      NounderBidsHistoryView(noun: noun)
        .pickerTabItem(R.string.bidHistory.menuTitle(), tag: 1)
    }
    // TODO: NavigationBar should support the translucent mode.
    .offset(y: -44)
    .padding(.bottom, -40)
    .softNavigationItems(leftAccessory: {
      // Dismisses Nounder Activities & Bids History
      SoftButton(
        icon: { Image.back },
        action: { isPresented.toggle() })
      
    }, rightAccessory: {
      SoftButton(
        icon: { Image.help },
        action: { isInfoPresented.toggle() })
    })
    .ignoresSafeArea(.all, edges: .bottom)
    .background(Gradient.warmGreydient)
    .bottomSheet(isPresented: $isInfoPresented) {
      NounDAOInfo(isPresented: $isInfoPresented)
    }
  }
}

struct NounDAOInfo: View {
  @Binding var isPresented: Bool
  @Environment(\.openURL) private var openURL
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Text(R.string.nounDAOInfo.title())
          .font(.custom(.bold, size: 36))
        
        Spacer()
        
        SoftButton(
          icon: { Image.xmark },
          action: { isPresented.toggle() })
      }
      
      Text(R.string.nounDAOInfo.description())
        .font(.custom(.regular, size: 17))
        .lineSpacing(5)
      
      SoftButton(
        text: R.string.shared.learnMore(),
        smallAccessory: { Image.squareArrowDown },
        action: {
          if let url = URL(string: "https://nouns.wtf") {
            openURL(url)
          }
        },
        fill: [.width])
    }
    .padding(16)
    .padding(.bottom, 4)
  }
  
}
