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
    let page: Page
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
            selection: page
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
