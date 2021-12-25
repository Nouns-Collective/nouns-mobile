//
//  CreateView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents
import Services

extension CreateExperience {
  
  final class ViewModel: ObservableObject {
    
    /// Holds vairous states.
    enum State {
      case loading
      case loaded([Noun])
      case empty
    }
    
    @Published var state: State = .loading
    
    private let offChainNounsService: OffChainNounsService
    
    init(offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService) {
      self.offChainNounsService = offChainNounsService
    }
  }
}

/// Displays the Create Experience route.
struct CreateExperience: View {
  @StateObject var viewModel = ViewModel()
  
  @State private var isPlaygroundPresented = false
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          OffChainNounsFeed(isPlaygroundPresented: $isPlaygroundPresented)
        }
        .fullScreenCover(isPresented: $isPlaygroundPresented) {
          NounPlayground()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, tabBarHeight)
        .padding(.bottom, 20) // Extra padding between the bottom of the last noun card and the top of the tab view
        .softNavigationTitle(R.string.create.title(), rightAccessory: { rightAccessory })
      }
      .background(Gradient.freshMint)
      .ignoresSafeArea(edges: .top)
    }
  }
  
  @ViewBuilder
  private var rightAccessory: some View {
    switch viewModel.state {
    case .empty:
      SoftButton(
        text: "New",
        largeAccessory: { Image.new },
        action: { isPlaygroundPresented.toggle() })
      
    default:
      EmptyView()
    }
  }
}

struct OffChainFeedPlaceholder: View {
  let action: () -> Void
  @Environment(\.nounComposer) private var nounComposer

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(R.string.create.subhealine())
        .font(.custom(.regular, size: 17))
      
      Spacer()

      // TODO: OffChainNoun && OnchainNoun conform to Noun
      // TODO: Integrate the NounPlayground to randomly generate Traits each time the view appear.
      NounPuzzle(
        head: nounComposer.heads[3].assetImage,
        body: nounComposer.bodies[6].assetImage,
        glasses: nounComposer.glasses[0].assetImage,
        accessory: nounComposer.accessories[0].assetImage)

      OutlineButton(
        text: R.string.create.proceedTitle(),
        largeAccessory: { Image.fingergunsRight },
        action: action)
        .controlSize(.large)

      Spacer()
    }
  }
}
