//
//  IntroductionOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

extension OnboardingView {
  
  struct IntroductionOnboardingView: View {
    
    @Binding var selectedPage: Page
    
    private func onboardingImages() -> [String] {
      let folder = Page.intro.assetFolder
      var images = [String]()
      
      for asset in 0..<Page.intro.numberOfAssets {
        let index = String(format: "%03d", asset)
        let imagePath = "\(folder)/\(folder)_\(index)"
        images.append(imagePath)
      }
      
      return images
    }
    
    var body: some View {
      VStack(spacing: 0) {
        ImageSlideshow(images: Page.intro.onboardingImages())
        
        OnboardingView.Footer(
          page: .intro,
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
            selectedPage = .explore
          }
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      .ignoresSafeArea()
      .background(Gradient.bubbleGum)
    }
  }
}
