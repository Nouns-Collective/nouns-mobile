//
//  OnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

/// An extension to conditionally show the onboarding screen
extension View {
  
  func onboarding() -> some View {
    modifier(OnboardingContent())
  }
}

/// A view modifier to conditionally show the onboarding screen above existing content
struct OnboardingContent: ViewModifier {
  @StateObject var viewModel = OnboardingView.ViewModel()
  
  func body(content: Content) -> some View {
    ZStack {
      if viewModel.showOnboarding {
        OnboardingView(viewModel: viewModel)
      } else {
        content
      }
    }
  }
}

struct OnboardingView: View {
  @ObservedObject var viewModel = ViewModel()
  
  var body: some View {
    TabView(selection: $viewModel.selectedPage) {
      
      IntroductionOnboardingView(
        viewModel: viewModel)
        .tag(OnboardingView.Page.intro)
      
      ExploreOnboardingView(
        viewModel: viewModel)
        .tag(OnboardingView.Page.explore)
      
      CreateOnboardingView(
        viewModel: viewModel)
        .tag(OnboardingView.Page.create)
      
      PlayOnboardingView(
        viewModel: viewModel)
        .tag(OnboardingView.Page.play)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .ignoresSafeArea()
  }
}
