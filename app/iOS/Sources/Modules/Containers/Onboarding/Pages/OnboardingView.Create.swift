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
      ZStack(alignment: .bottom) {
        Image(R.image.onboardingCreateBackground.name)
          .resizable()
          .scaledToFill()
        
        VStack {
          Spacer()
          
          Image(R.image.createNounPizza.name)
            .resizable()
            .scaledToFit()
        }
      }
      
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
    }
    .ignoresSafeArea()
    .background(Gradient.freshMint)
  }
}
