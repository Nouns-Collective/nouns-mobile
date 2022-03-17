//
//  PlayOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

struct PlayOnboardingView: View {
  @ObservedObject var viewModel: OnboardingView.ViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      ImageSlideshow(images: viewModel.onboardingImages())
      
      OnboardingView.Footer(
        viewModel: viewModel,
        title: R.string.onboarding.play()
      ) {
        OutlineButton {
          HStack(spacing: 10) {
            Text("Get Started")
              .font(Font.custom(.medium, size: 17))
            
            Image.PointRight.standard
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 24, alignment: .center)
          }
          .padding(16)
        } action: {
          withAnimation {
            viewModel.toggleCompletionState()
          }
        }
      }
      .fixedSize(horizontal: false, vertical: true)
    }
    .ignoresSafeArea()
    .background(Gradient.blueberryJam)
  }
}
