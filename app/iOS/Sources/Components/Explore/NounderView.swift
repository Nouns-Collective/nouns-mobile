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
  @EnvironmentObject var store: AppStore
  @State private var selectedTab = 0
  @State private var isInfoPresented = false
  @Binding var isPresented: Bool
  @Environment(\.openURL) private var openURL
  
  let noun: Noun
  
  var body: some View {
    PickerTabView(selection: $selectedTab) {
      
      NounderActivitiesView(noun: noun)
        .pickerTabItem("Activties", tag: 0)
      
      NounderBidsHistoryView(noun: noun)
        .pickerTabItem("Bid history", tag: 1)
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
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("What is this?")
            .font(.custom(.bold, size: 36))
          
          Spacer()
          
          SoftButton(
            icon: { Image.xmark },
            action: { isInfoPresented.toggle() })
        }
        
        Text("Each noun is a member of the Nouns DAO and entitled to one vote in all governance matters. This means, once Noun 62 was owned by beautifulpunks.eth, they could vote on proposals to the DAO and this is their voting activity.")
          .font(.custom(.regular, size: 17))
          .lineSpacing(5)
        
        SoftButton(
          text: "Learn more",
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
}
