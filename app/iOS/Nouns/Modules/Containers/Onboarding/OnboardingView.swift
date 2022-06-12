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
  
  @StateObject private var viewModel = ViewModel()
    
  @Binding private var isPresented: Bool
  private let onCompletion: () -> Void
    
  init(isPresented: Binding<Bool>, onCompletion: @escaping () -> Void) {
    self._isPresented = isPresented
    self.onCompletion = onCompletion
    UITabBar.appearance().alpha = 0.0
  }
  
  var body: some View {
    NavigationView {
      RootOnboardingView(viewModel: viewModel, isPresented: $isPresented)
        .ignoresSafeArea()
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
          viewModel.onCompletion = self.onCompletion
        }
    }
  }
}

extension OnboardingView {
  
  /// Lists all Onboarding pages.
  enum Page: Int, Hashable, CaseIterable {
    case intro
    case explore
    case create
    
    func nextPage() -> Page? {
      switch self {
      case .intro:
        return .explore
      case .explore:
        return .create
      case .create:
        return nil
      }
    }
  }
}
