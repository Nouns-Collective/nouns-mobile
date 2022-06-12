// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI

extension NounCreator {
  
  struct TraitTypeSegmentedControl: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var selectedTraitType: Int
    
    @Namespace private var typeSelectionNamespace
    
    var body: some View {
      ScrollView(.horizontal, showsIndicators: false) { proxy in
        // Displays all Noun's trait types in a segement control.
        OutlinePicker(selection: $selectedTraitType) {
          ForEach(TraitType.allCases, id: \.rawValue) { type in
            Text(type.description)
              .id(type.rawValue)
              .scrollId(type.rawValue)
              .pickerItemTag(type.rawValue, namespace: typeSelectionNamespace)
              .simultaneousGesture(
                TapGesture()
                  .onEnded { _ in
                    viewModel.didTapTraitType(to: .init(rawValue: type.rawValue) ?? .glasses)
                  }
              )
          }
        }
        .padding(.horizontal)
        .onChange(of: selectedTraitType) { newValue in
          withAnimation {
            proxy.scrollTo(newValue, alignment: .center, animated: true)
          }
        }
      }
    }
  }
}
