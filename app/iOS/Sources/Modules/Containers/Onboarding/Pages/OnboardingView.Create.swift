//
//  CreateOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

extension OnboardingView {
  
  struct CreateOnboardingView: View {
    
    @Binding var isPresented: Bool
    
    let onCompletion: () -> Void
    
    var body: some View {
      VStack(spacing: 0) {
        ImageSlideshow(images: Page.create.onboardingImages())
        
        OnboardingView.Footer(
          page: .create,
          title: R.string.onboarding.create()
        ) {
          OutlineButton {
            HStack(spacing: 10) {
              Text(R.string.shared.getStarted())
                .font(Font.custom(.medium, relativeTo: .subheadline))
              
              Image.PointRight.standard
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24, alignment: .center)
            }
            .padding(16)
          } action: {
            isPresented = false
            onCompletion()
          }
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      .ignoresSafeArea()
      .background(Gradient.freshMint)
    }
  }
}
