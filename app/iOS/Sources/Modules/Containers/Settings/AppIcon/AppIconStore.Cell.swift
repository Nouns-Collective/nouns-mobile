//
//  AppIconCell.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.12.21.
//

import SwiftUI
import UIComponents

extension AppIconStore {
  
  struct Cell: View {
    let icon: AppIcon
    @Binding var selection: String?
    
    @Environment(\.nounComposer) private var nounComposer
    
    private var backgroundFillColor: Color {
      isSelected ? .componentNounsBlack.opacity(0.3) : .white
    }
    
    private var textColor: Color {
      isSelected ? .white : .componentNounsBlack
    }
    
    private var isSelected: Bool {
      selection == icon.asset
    }
    
    var body: some View {
      VStack(spacing: 10) {
        Image(icon.preview)
          .foregroundColor(.gray)
          .cornerRadius(15.6)
          .padding(.horizontal, 20)
          
        HStack {
          Text(icon.name)
            .font(.custom(.medium, relativeTo: .caption))
            .foregroundColor(textColor)
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 20)
      .border(.black, lineWidth: 2, fillColor: backgroundFillColor, cornerRadius: 8)
      .onTapGesture {
        UIApplication.shared.setAlternateIconName(icon.asset) { error in
          print("Error: \(error)")
          
          withAnimation {
            selection = icon.asset
          }
        }
      }
    }
  }
}
