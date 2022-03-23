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
    let index: Int
    @Binding var selection: Int 
    
    @Environment(\.nounComposer) private var nounComposer
    
    private var backgroundFillColor: Color {
      isSelected ? .componentNounsBlack.opacity(0.2) : .white
    }
    
    private var background: Color {
      guard let colorHex = nounComposer.backgroundColors.randomElement() else {
        return Color.componentWarmGrey
      }
      return Color(hex: colorHex)
    }
    
    private var isSelected: Bool {
      selection == index
    }
    
    var body: some View {
      VStack(spacing: 10) {
        ZStack {
          Image(nounTraitName: nounComposer.heads[index].assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: 60, height: 60)
            .offset(y: 5)
          
          Image(nounTraitName: nounComposer.glasses.randomElement()!.assetImage)
            .interpolation(.none)
            .resizable()
            .frame(width: 60, height: 60)
            .offset(y: 5)
        }
        .frame(width: 42, height: 42)
        .foregroundColor(.gray)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(background)
        .cornerRadius(20)
        
        HStack {
          Text("Default")
            .font(.custom(.medium, relativeTo: .caption))
          
          if isSelected {
            Image.check
              .renderingMode(.template)
              .foregroundColor(.black)
          }
        }
      }
      .padding(.vertical, 15)
      .padding(.horizontal, 20)
      .border(.black, lineWidth: 2, fillColor: backgroundFillColor, cornerRadius: 8)
      .onTapGesture {
        selection = index
      }
    }
  }
}
