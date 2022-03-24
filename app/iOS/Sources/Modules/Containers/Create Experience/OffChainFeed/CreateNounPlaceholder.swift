//
//  CreateNounPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-26.
//

import SwiftUI
import UIComponents
import Services

extension CreateExperience {
  
  /// A placeholder view for the Create tab for when the user has no created nouns
  struct EmptyNounsView: View {
    
    @Environment(\.outlineTabViewHeight) private var tabBarHeight
    
    private let initialSeed: Seed
    
    private let action: () -> Void
        
    @Binding var isCreatorPresented: Bool
        
    init(
      initialSeed: Seed = Seed.default,
      isCreatorPresented: Binding<Bool>,
      action: @escaping () -> Void
    ) {
      self.initialSeed = initialSeed
      self._isCreatorPresented = isCreatorPresented
      self.action = action
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.create.subhealine())
          .font(.custom(.regular, relativeTo: .subheadline))
          .padding(.horizontal, 20)
        
        Spacer()
                  
        SlotMachine(
          initialSeed: initialSeed,
          showShadow: false,
          animateEntrance: true
        )
          .disabled(true)
          .drawingGroup()

        OutlineButton(
          text: R.string.create.proceedTitle(),
          largeAccessory: { Image.fingergunsRight.shakeRepeatedly() },
          action: action)
          .controlSize(.large)
          .padding(.horizontal, 40)
        
        Spacer()
      }
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun card and the top of the tab view
      .padding(.bottom, 20)
      .softNavigationTitle(R.string.create.title(), rightAccessory: {
        SoftButton(
          text: "New",
          largeAccessory: { Image.new },
          action: { isCreatorPresented.toggle() })
      })
    }
  }
}