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
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          OfflineFeed(nouns)
        }
        .offlineFeedPlaceholder(isDisplayed: nouns.isEmpty) {
          isPlaygroundPresented.toggle()
        }
        .fullScreenCover(isPresented: $isPlaygroundPresented) {
          NounPlayground()
        }
        .padding(.horizontal, 20)
        .softNavigationTitle(R.string.explore.title(), rightAccessory: {
          newBarItem
        })
      }
      .background(Gradient.freshMint)
      .ignoresSafeArea()
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
  // Namespace should be renamed to be clear
  @Namespace private var namespace
  @State private var selectedNoun: OfflineNoun?
  @State private var isProfilePresented = false
  
  init(_ nouns: Result) {
    self.nouns = nouns
  }
  
  var body: some View {
    // TODO: Build a reusable List to display cards and other components rather having multiple nested views.
    ForEach(nouns, id: \.self) { noun in
      OfflineNounCard(animation: namespace, noun: noun)
      // TODO: Explore if the animation could be build using  `AnimatableModifier`: Low Priority.
        .id(noun.id)
        .matchedGeometryEffect(id: "noun-\(noun.id)", in: namespace)
        .onTapGesture {
          selectedNoun = noun
          isProfilePresented.toggle()
        }
    }
    // TODO: Replace fullScreenCover with a `HeroAnimation`
    .fullScreenCover(item: $selectedNoun) { noun in
      OffChainNounProfile(isPresented: $isProfilePresented, noun: noun)
    }
    // TODO: ViewState should not belong here.
    .onChange(of: isProfilePresented) { newValue in
      if isProfilePresented == false {
        selectedNoun = nil
      }
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
      
      // TODO: OffChainNoun && OnchainNoun conform to Noun
      // NounPuzzle(noun: noun)
      // TODO: Integrate the NounPlayground to randomly generate Traits each time the view appear.
//      NounPuzzle(
//        head: Image(nounTraitName: nounComposer.heads[3].assetImage),
//        body: Image(nounTraitName: nounComposer.bodies[6].assetImage),
//        glass: Image(nounTraitName: nounComposer.glasses[0].assetImage),
//        accessory: Image(nounTraitName: nounComposer.accessories[0].assetImage))
      Color.red
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
