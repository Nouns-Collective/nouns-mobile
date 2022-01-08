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
      ZStack(alignment: .bottom) {
        Image(R.image.onboardingPlayBackground.name)
          .resizable()
          .scaledToFill()
        
        VStack(spacing: 0) {
          Spacer()
          
          Image(R.image.homeSliceChat.name)
            .resizable()
            .scaledToFit()
            .frame(height: 112, alignment: .center)
          
          Image(R.image.pizzaNoun.name)
            .resizable()
            .scaledToFit()
        }
      }
      
      OnboardingView.Footer(
        viewModel: viewModel,
        title: R.string.onboarding.play()
      ) {
        OutlineButton {
          HStack(spacing: 10) {
            Text("Get Started")
              .font(Font.custom(.medium, size: 17))
            
            Image.pointRight.standard
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
    }
    .ignoresSafeArea()
    .background(Gradient.blueberryJam)
  }
}
