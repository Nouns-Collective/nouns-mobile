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
      ZStack {
        Image(R.image.onboardingNounBackground.name)
          .resizable()
          .scaledToFill()
        
        VStack {
          Spacer()
          
          Image(R.image.sharkNoun.name)
            .resizable()
            .scaledToFit()
        }
      }
      
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
    }
    .ignoresSafeArea()
    .background(Gradient.bubbleGum)
  }
}
