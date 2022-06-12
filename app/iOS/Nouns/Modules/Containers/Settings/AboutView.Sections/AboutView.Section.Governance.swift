// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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
import Services

extension GovernanceInfoSection {
  
  final class ViewModel: ObservableObject {
    @Published var treasury = "..."
    ///
    private let onChainNouns: OnChainNounsService
    
    init(
      onChainNouns: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.onChainNouns = onChainNouns
    }
    
    @MainActor
    func fetchTreasury() {
      Task {
        do {
          let balance = try await onChainNouns.fetchTreasury()
          
          guard let ethBalance = EtherFormatter.eth(
            from: balance,
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
          ) else { return }
          
          treasury = ethBalance 
          
        } catch { }
      }
    }
  }
}

struct GovernanceInfoSection: View {
  @StateObject var viewModel = ViewModel()
  @Binding var isAboutNounsPresented: Bool
  
  private let localize = R.string.about.self
  
  var body: some View {
    VStack {
      PlainCell {
        HStack(alignment: .center) {
          
          Label(title: {
            Text(localize.treasury())
              .font(.custom(.medium, relativeTo: .caption))
            
          }, icon: {
            Image.nounLogo
              .resizable()
              .frame(width: 9.43, height: 12)
          })
            .background(Gradient.mangoChunks)
            .clipShape(Capsule())
            .frame(width: 95, height: 23)
          
          Spacer()
          
          Label(title: {
            Text(viewModel.treasury)
              .font(.custom(.bold, relativeTo: .title3))
            
          }, icon: {
            Image.eth
              .resizable()
              .frame(width: 20, height: 20)
          })
        }.padding()
      }
      .onAppear {
        viewModel.fetchTreasury()
      }
      
      SoftButton(
        text: localize.learnMore(),
        icon: { Image.web },
        smallAccessory: { Image.smArrowOut },
        action: {
          withAnimation {
            isAboutNounsPresented.toggle()
          }
        })
        .controlSize(.large)
    }
  }
}
