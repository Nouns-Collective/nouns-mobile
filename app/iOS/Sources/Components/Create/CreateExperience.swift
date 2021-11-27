//
//  CreateView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

/// Displays the Create Experience route.
struct CreateExperience: View {
  @State private var isPlaygroundPresented = false
  
  @FetchRequest(
    entity: OfflineNoun.entity(),
    sortDescriptors: OfflineNoun.defaultSortDescriptors
  ) private var nouns: FetchedResults<OfflineNoun>
  
  var body: some View {
    NavigationView {
      OfflineFeed(nouns)
        .offlineFeedPlaceholder(isDisplayed: nouns.isEmpty) {
          isPlaygroundPresented.toggle()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .softNavigationTitle(
          R.string.create.title(),
          rightAccessory: { newBarItem }
        )
        .background(Gradient.freshMint)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isPlaygroundPresented) {
          NounPlayground()
        }
    }
  }
  
  private var newBarItem: some View {
    guard !nouns.isEmpty else {
      return AnyView(EmptyView())
    }
    
    return AnyView(SoftButton(
      text: "New",
      largeAccessory: { Image.new },
      action: { isPlaygroundPresented.toggle() }))
  }
}

/// A view to display a list of all the nouns that the user has created.
struct OfflineFeed<Result: RandomAccessCollection>: View where Result.Element == OfflineNoun {
  private let nouns: Result
  @Namespace private var namespace
  
  init(_ nouns: Result) {
    self.nouns = nouns
  }
  
  var body: some View {
    List(nouns) {
      OfflineNounCard(animation: namespace, noun: $0)
    }
  }
}

/// Placeholder while no offline Noun is generated.
extension View {
  
  func offlineFeedPlaceholder(isDisplayed: Bool, action: @escaping () -> Void) -> some View {
    modifier(OfflineFeedPlaceholder(isDisplayed: isDisplayed, action: action))
  }
}

struct OfflineFeedPlaceholder: ViewModifier {
  let isDisplayed: Bool
  let action: () -> Void
  @Environment(\.nounComposer) private var nounComposer
  
  func body(content: Content) -> some View {
    isDisplayed ? AnyView(placeholder) : AnyView(content)
  }
  
  private var placeholder: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(R.string.create.subhealine())
        .font(.custom(.regular, size: 17))
      
      NounPuzzle(
        head: Image(nounTraitName: nounComposer.heads[3].assetImage),
        body: Image(nounTraitName: nounComposer.bodies[6].assetImage),
        glass: Image(nounTraitName: nounComposer.glasses[0].assetImage),
        accessory: Image(nounTraitName: nounComposer.accessories[0].assetImage))
        .padding(.top, 40)
      
      OutlineButton(
        text: R.string.create.proceedTitle(),
        largeAccessory: { Image.fingergunsRight },
        action: action,
        fill: [.width])
      
      Spacer()
    }
  }
}
