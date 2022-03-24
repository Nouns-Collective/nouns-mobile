//
//  CreateOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

struct CreateOnboardingView: View {
  @ObservedObject var viewModel: OnboardingView.ViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      ImageSlideshow(images: viewModel.onboardingImages())
      
      OnboardingView.Footer(
        viewModel: viewModel,
        title: R.string.onboarding.create()
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
          viewModel.selectedPage = .play
        }
      }
      .fixedSize(horizontal: false, vertical: true)
    }
    .ignoresSafeArea()
    .background(Gradient.freshMint)
  }
}
