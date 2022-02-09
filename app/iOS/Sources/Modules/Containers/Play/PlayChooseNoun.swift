//
//  PlayChooseNoun.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-08.
//

import SwiftUI
import UIComponents
import Services

struct PlayChooseNoun: View {
  @Namespace private var namespace
  @Environment(\.outlineTabViewHeight) var tabBarHeight
  @Environment(\.dismiss) private var dismiss
  
  @StateObject private var viewModel: ViewModel = ViewModel()
  
  @State private var selectedNoun: Noun?
  @State private var isCreatorPresented: Bool = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      OffChainNounsFeed(
        title: R.string.play.chooseNoun(),
        selection: $selectedNoun
      ) {
        PlayChooseNounPlaceholder {
          isCreatorPresented.toggle()
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 20)
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
    .task {
      await viewModel.fetchOffChainNouns()
    }
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

extension PlayChooseNoun {
  
  @MainActor
  final class ViewModel: ObservableObject {
    @Published var nouns = [Noun]()
    @Published var isFetching = false
    
    private let offChainNounsService: OffChainNounsService
    
    init(offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService) {
      self.offChainNounsService = offChainNounsService
    }
    
    func fetchOffChainNouns() async {
      // when
      do {
        for try await nouns in offChainNounsService.nounsStoreDidChange(ascendingOrder: false) {
          self.nouns = nouns
        }
      } catch {
        print("Error: \(error)")
      }
    }
  }
}
