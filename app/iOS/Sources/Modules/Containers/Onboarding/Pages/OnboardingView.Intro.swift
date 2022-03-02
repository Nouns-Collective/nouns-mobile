//
//  IntroductionOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

struct IntroductionOnboardingView: View {
  @ObservedObject var viewModel: OnboardingView.ViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      ImageSequence(images: viewModel.onboardingImages())
      
      OnboardingView.Footer(
        viewModel: viewModel,
        title: R.string.onboarding.introduction()
      ) {
        OutlineButton {
          HStack(spacing: 10) {
            Image.mdArrowRight
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 24, alignment: .center)
          }
          .padding(16)
        } action: {
          viewModel.selectedPage = .explore
        }
      }
      .fixedSize(horizontal: false, vertical: true)
    }
    .ignoresSafeArea()
    .background(Gradient.bubbleGum)
  }
}
