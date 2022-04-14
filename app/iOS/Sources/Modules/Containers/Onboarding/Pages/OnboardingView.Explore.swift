//
//  ExploreOnboardingView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI
import UIComponents

extension OnboardingView {
  
  struct ExploreOnboardingView: View {

    @Binding var selectedPage: Page
    
    private func onboardingImages() -> [String] {
      let folder = Page.explore.assetFolder
      var images = [String]()
      
      for asset in 0..<Page.explore.numberOfAssets {
        let index = String(format: "%03d", asset)
        let imagePath = "\(folder)/\(folder)_\(index)"
        images.append(imagePath)
      }
      
      return images
    }
    
    var body: some View {
      VStack(spacing: 0) {
        ImageSlideshow(images: Page.explore.onboardingImages())
        
        OnboardingView.Footer(
          page: .explore,
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
            selectedPage = .create
          }
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      .ignoresSafeArea()
      .background(Gradient.lemonDrop)
    }
  }
}
