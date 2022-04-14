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
  
  /// Shows the onboarding view sequence
  ///
  /// - Parameters:
  ///   - isPresented: A binding boolean to determine if the onboarding view should be shown
  ///   - onCompletion: An optional additional method to run after the onboarding sequence has completed
  func onboarding(_ isPresented: Binding<Bool>, onCompletion: @escaping () -> Void = {}) -> some View {
    modifier(OnboardingContent(isPresented: isPresented, onCompletion: onCompletion))
  }
}

/// A view modifier to conditionally show the onboarding screen above existing content
struct OnboardingContent: ViewModifier {
  @Binding var isPresented: Bool
  
  let onCompletion: () -> Void
  
  func body(content: Content) -> some View {
    ZStack {
      if isPresented {
        OnboardingView(isPresented: $isPresented, onCompletion: onCompletion)
          .zIndex(.infinity)
      }
      
      content
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    .navigationBarBackButtonHidden(true)
  }
}

struct OnboardingView: View {
  @State private var selectedPage: Page = .intro
  
  @Binding private var isPresented: Bool
  
  private let onCompletion: () -> Void
  
  init(isPresented: Binding<Bool>, onCompletion: @escaping () -> Void) {
    self._isPresented = isPresented
    self.onCompletion = onCompletion
    UITabBar.appearance().alpha = 0.0
  }
  
  var body: some View {
    NavigationView {
      TabView(selection: $selectedPage) {

        IntroductionOnboardingView(
          selectedPage: $selectedPage
        )
          .tag(OnboardingView.Page.intro)

        ExploreOnboardingView(
          selectedPage: $selectedPage
        )
          .tag(OnboardingView.Page.explore)

        CreateOnboardingView(
          isPresented: $isPresented,
          onCompletion: onCompletion
        )
          .tag(OnboardingView.Page.create)
      }
      .ignoresSafeArea()
      .navigationTitle("")
      .navigationBarHidden(true)
      .navigationBarBackButtonHidden(true)
    }
  }
}

extension OnboardingView {
  
  /// Lists all Onboarding pages.
  enum Page: Hashable, CaseIterable {
    case intro
    case explore
    case create
    
    /// The folder in which to find the frames for each onboarding page's image sequence background
    var assetFolder: String {
      switch self {
      case .intro:
        return "nouns-onboarding-1"
      case .explore:
        return "nouns-onboarding-2"
      case .create:
        return "nouns-onboarding-3"
      }
    }
    
    /// The number of onboarding images (frames for an image sequence video) each onboarding page has
    var numberOfAssets: Int {
      switch self {
      case .intro, .explore, .create:
        return 120
      }
    }
    
    func onboardingImages() -> [String] {
      let folder = self.assetFolder
      var images = [String]()
      
      for asset in 0..<self.numberOfAssets {
        let index = String(format: "%03d", asset)
        let imagePath = "\(folder)/\(folder)_\(index)"
        images.append(imagePath)
      }
      
      return images
    }
  }
}
