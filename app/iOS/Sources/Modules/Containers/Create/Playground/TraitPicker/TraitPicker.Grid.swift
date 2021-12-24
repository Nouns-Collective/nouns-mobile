//
//  TraitGrid.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI

extension NounPlayground {
  
  struct TraitTypeGrid: View {
    @ObservedObject var viewModel: ViewModel
    
    private let rowSpec = [
      GridItem(.flexible(), spacing: 4),
      GridItem(.flexible(), spacing: 4),
      GridItem(.flexible(), spacing: 4),
    ]
    
    var body: some View {
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {

          LazyHGrid(rows: rowSpec, spacing: 4) {
            
            // Trait selection
            ForEach(ViewModel.TraitType.allCases, id: \.rawValue) { type in
              TraitCollectionSection(items: type.traits) { trait, index in
                TraitPickerItem(image: trait.assetImage)
                  .selected(viewModel.isSelected(index, traitType: type))
                  .onTapGesture {
                    viewModel.selectTrait(index, ofType: type)
                  }
                  .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
              }
            }
            
            // Gradient background selection
            TraitCollectionSection(items: Gradient.allGradients) { gradient, index in
              GradientPickerItem(colors: gradient)
                .selected(viewModel.isSelected(index, traitType: .background))
                .onTapGesture {
                  viewModel.selectTrait(index, ofType: .background)
                }
                .padding(.leading, (0..<rowSpec.count).contains(index) ? 20 : 0)
            }
          }
          .padding(.vertical, 12)
  //        .onChange(of: playgroundState.selectedTraitType, perform: { newTrait in
  //          withAnimation {
  //            proxy.scrollTo("\(newTrait)-0", anchor: .leading)
  //          }
  //        })
//          .onChange(of: viewModel.seed, perform: { seed in
//            withAnimation {
//              proxy.scrollTo("\(viewModel.sel)-\(seed[playgroundState.selectedTraitType])", anchor: .center)
//            }
//          })
  //        .onAppear(perform: {
  //          proxy.scrollTo("\(playgroundState.selectedTraitType)-\(playgroundState.seed[playgroundState.selectedTraitType])", anchor: .leading)
  //        })
        }
        .frame(maxHeight: 250)
      }
    }
  }
}
