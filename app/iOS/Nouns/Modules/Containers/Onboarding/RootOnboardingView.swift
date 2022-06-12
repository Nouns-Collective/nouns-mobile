// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI
import Services
import SpriteKit

extension OnboardingView {
  
  struct RootOnboardingView: View {
        
    @ObservedObject var viewModel: ViewModel
    
    @Binding var isPresented: Bool

    @State private var scene: IntroScene = IntroScene(size: .zero)
    
    @State private var size: CGSize = .zero
    
    private var backgroundGradient: some View {
      switch viewModel.selectedPage {
      case .intro:
        return Gradient.bubbleGum
      case .explore:
        return Gradient.lemonDrop
      case .create:
        return Gradient.freshMint
      }
    }
    
    private var onboardingScene: SKScene {
      switch viewModel.selectedPage {
      case .intro:
        return IntroScene(size: size)
      case .explore:
        return ExploreScene(size: size)
      case .create:
        return CreateScene(size: size)
      }
    }
    
    private var footerTitle: String {
      switch viewModel.selectedPage {
      case .intro:
        return R.string.onboarding.introduction()
      case .explore:
        return R.string.onboarding.explore()
      case .create:
        return R.string.onboarding.create()
      }
    }
    
    private var marqueeColor: Color {
      switch viewModel.selectedPage {
      case .intro:
        return Color.componentRaspberry
      case .explore:
        return Color(.sRGB, red: 250 / 255, green: 193 / 255, blue: 138 / 255, opacity: 1.0)
      case .create:
        return Color(.sRGB, red: 116 / 255, green: 227 / 255, blue: 160 / 255, opacity: 1.0)
      }
    }
    
    private var marqueeText: String {
      switch viewModel.selectedPage {
      case .intro:
        return "noun"
      case .explore:
        return "explore"
      case .create:
        return "create"
      }
    }
    
    var body: some View {
      VStack(spacing: 0) {
        ZStack(alignment: .bottom) {
          GeometryReader { proxy in
            ZStack {
              BackgroundMarquee(repeatingText: marqueeText, textColor: marqueeColor)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .clipped()
                .hidden(viewModel.selectedPage == .explore)
              
              SpriteView(scene: onboardingScene, options: [.allowsTransparency])
                .id(viewModel.selectedPage.rawValue) // Needed to invoke a "refresh" on the current scene in the `SpriteView` above.
                .onChange(of: proxy.size) { newSize in
                  self.size = newSize
                }
            }
          }

          if viewModel.selectedPage == .create {
            TimelineView(.periodic(from: .now, by: 3.75)) { context in
              RotatingSlotMachine(date: context.date)
            }
          }
        }
        
        OnboardingView.Footer(
          page: viewModel.selectedPage,
          title: footerTitle
        ) {
          OutlineButton {
            HStack(spacing: 20) {
              if viewModel.selectedPage == .create {
                Text(R.string.shared.getStarted())
                  .font(Font.custom(.medium, relativeTo: .subheadline))
                
                Image.fingergunsRight
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 28, alignment: .center)
                  .shakeRepeatedly()
              } else {
                Image.mdArrowRight
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 28, alignment: .center)
              }
            }
            .padding(16)
          } action: {
            if let nextPage = viewModel.selectedPage.nextPage() {
              viewModel.selectedPage = nextPage
            } else {
              isPresented = false
              viewModel.onCompletion()
            }
          }
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      .ignoresSafeArea()
      .background(backgroundGradient)
    }
  }
  
  struct RotatingSlotMachine: View {
    
    let date: Date

    @State private var seed: Seed = .pizza
    
    var body: some View {
      SlotMachine(
        seed: $seed,
        shouldShowAllTraits: .constant(true),
        showShadow: false,
        animateEntrance: false,
        imageWidth: UIScreen.main.bounds.width
      )
      .disabled(true)
      .drawingGroup()
      .animation(.timingCurve(1, 0, 0, 1, duration: 1.7).delay(0.8), value: seed)
      .onChange(of: date) { _ in
        seed = AppCore.shared.nounComposer.newRandomSeed(previous: seed)
      }
    }
  }
  
  struct BackgroundMarquee: View {
    
    /// The text to loop in the background
    let repeatingText: String
    
    /// The color of the text
    let textColor: Color
    
    var body: some View {
      VStack(spacing: 0) {
        ForEach(0...20, id: \.self) { index in
          MarqueeText(text: Array(repeating: repeatingText, count: 10).joined(separator: " ").appending(" "), alignment: .center, font: UIFont.custom(.bold, size: 48))
            .offset(x: CGFloat(-10 * index), y: 0)
            .foregroundColor(textColor)
            .colorMultiply(textColor.opacity(0.1))
        }
      }
    }
  }
}
