//
//  OfflineFeed.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import UIComponents
import Services

/// A view to display a list of all the nouns that the user has created.
struct OffChainNounsFeed: View {
  @StateObject var viewModel = ViewModel()
  @Binding var isPlaygroundPresented: Bool
  
  @State private var selection: Noun?
  @Namespace private var namespace
  
  var body: some View {
    VStack(spacing: 20) {
      ForEach(viewModel.nouns, id: \.id) { noun in
        OffChainNounCard(viewModel: .init(noun: noun), animation: namespace)
          .id(noun.id)
          .onTapGesture {
            selection = noun
          }
      }
    }
    .emptyPlaceholder(when: viewModel.nouns.isEmpty) {
      OffChainFeedPlaceholder {
        isPlaygroundPresented.toggle()
      }
    }
    .onAppear {
      viewModel.fetchOffChainNouns()
    }
    // Presents more details about the settled auction.
    .fullScreenCover(item: $selection, onDismiss: {
      selection = nil

    }, content: {
      OffChainNounProfile(viewModel: .init(noun: $0))
    })
  }
}

extension OffChainNounsFeed {
  
  @MainActor
  final class ViewModel: ObservableObject {
    @Published var nouns = [Noun]()
    @Published var isFetching = false
    
    private let pageLimit = 20
    private let offChainNounsService: OffChainNounsService
    
    init(offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService) {
      self.offChainNounsService = offChainNounsService
    }
    
    func fetchOffChainNouns() {
      do {
        nouns += try offChainNounsService.fetchNouns(
          limit: pageLimit,
          cursor: nouns.count,
          ascending: false
        )
        
      } catch {
        
      }
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
