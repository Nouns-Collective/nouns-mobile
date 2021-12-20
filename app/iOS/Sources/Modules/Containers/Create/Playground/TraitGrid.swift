//
//  TraitGrid.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI

struct TraitGrid: View {
  @EnvironmentObject private var store: AppStore
  
  private var playgroundState: PlaygroundState {
    store.state.playground
  }
  
  private let rowSpec = [
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible(), spacing: 4),
  ]
  
  /// Traits displayed in the grid in this specific order, matching the outline picker
  private let traits = [
    AppCore.shared.nounComposer.glasses,
    AppCore.shared.nounComposer.heads,
    AppCore.shared.nounComposer.bodies,
    AppCore.shared.nounComposer.accessories
  ]
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: rowSpec, spacing: 4) {
          // Trait selection
          ForEach(0..<traits.count) { trait in
            TraitCollectionSection(tag: trait, items: traits[trait]) { item, index in
              TraitPickerItem(image: item.assetImage)
                .selected(playgroundState.seed[trait] == index)
                .id("\(trait)-\(index)")
                .onTapGesture {
                  store.dispatch(PlaygroundUpdateTraitItem(trait: trait, item: index))
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
          }
          
          // Gradient background selection
          TraitCollectionSection(tag: 4, items: Gradient.allGradients) { gradient, index in
            GradientPickerItem(colors: gradient)
              .selected(playgroundState.seed[4] == index)
              .id("4-\(index)")
              .onTapGesture {
                store.dispatch(PlaygroundUpdateTraitItem(trait: 4, item: index))
              }
              .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
          }
        }
        .padding(.vertical, 12)
        .onChange(of: playgroundState.selectedTraitType, perform: { newTrait in
          withAnimation {
            proxy.scrollTo("\(newTrait)-0", anchor: .leading)
          }
        })
        .onChange(of: playgroundState.seed, perform: { seed in
          withAnimation {
            proxy.scrollTo("\(playgroundState.selectedTraitType)-\(seed[playgroundState.selectedTraitType])", anchor: .center)
          }
        })
        .onAppear(perform: {
          proxy.scrollTo("\(playgroundState.selectedTraitType)-\(playgroundState.seed[playgroundState.selectedTraitType])", anchor: .leading)
        })
      }
      .frame(maxHeight: 250)
    }
  }
}
