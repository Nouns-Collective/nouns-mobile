//
//  OnboardingFooterView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

extension OnboardingView {
  
  struct Footer<Trailing: View>: View {
    @ObservedObject var viewModel: OnboardingView.ViewModel
    let title: String
    let trailing: () -> Trailing
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.custom(.bold, relativeTo: .title2))
          .foregroundColor(Color.componentNounsBlack)
          .multilineTextAlignment(.leading)
        
        Spacer()
        
        HStack(alignment: .bottom) {
          PageIndicator(
            pages: OnboardingView.Page.allCases,
            selection: viewModel.selectedPage
          )
          
          Spacer()
          
          trailing()
        }
      }
      .padding(30)
      .padding(.bottom, 30)
      .background(Color.clear)
      .border(width: 2, edges: [.top], color: .componentNounsBlack)
    }
  }
}
