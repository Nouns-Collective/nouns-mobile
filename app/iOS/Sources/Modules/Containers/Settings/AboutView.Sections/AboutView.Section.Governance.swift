//
//  AboutView.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents
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
          treasury = EtherFormatter.eth(from: balance) ?? "..."
          
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
              .font(.custom(.medium, size: 13))
            
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
              .font(.custom(.bold, size: 24))
            
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
