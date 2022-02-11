//
//  PlayChooseNoun.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-08.
//

import SwiftUI
import UIComponents
import Services

struct PlayNounPicker: View {
  @Namespace private var namespace
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  @Environment(\.dismiss) private var dismiss
    
  @State private var selectedNoun: Noun?
  @State private var isCreatorPresented: Bool = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      OffChainNounsFeed(
        title: R.string.play.chooseNoun(),
        selection: $selectedNoun
      ) {
        EmptyNounsView {
          isCreatorPresented.toggle()
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 20)
      .padding(.bottom, tabBarHeight)
      .softNavigationItems(leftAccessory: {
        SoftButton(
          icon: { Image.back },
          action: { dismiss() })
      }, rightAccessory: {
        SoftButton(
          text: "New",
          largeAccessory: { Image.new },
          action: {
            isCreatorPresented.toggle()
          })
      })
    }
    .background(Gradient.blueberryJam)
    .fullScreenCover(isPresented: $isCreatorPresented) {
      NounCreator(viewModel: .init())
    }
    .fullScreenCover(item: $selectedNoun) {
      selectedNoun = nil
    } content: { noun in
      NounPlayground(noun: noun)
    }
  }
}
