//
//  ExploreOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

struct ExploreOnboardingView: View {
  @ObservedObject var viewModel: OnboardingView.ViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .bottom) {
        Image(R.image.onboardingExploreBackground.name)
          .resizable()
          .scaledToFill()
        
        Image(R.image.exploreOnboarding.name)
          .resizable()
          .scaledToFit()
      }
      
      OnboardingView.Footer(
        viewModel: viewModel,
        title: R.string.onboarding.explore()
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
          viewModel.selectedPage = .create
        }
      }
    }
    .ignoresSafeArea()
    .background(Gradient.lemonDrop)
  }
}
