//
//  AboutView.Title.swift
//  Nouns
//
//  Created by Ziad Tamim on 08.12.21.
//

import SwiftUI

extension AboutView {
  
  /// About Section title.
  struct SectionTitle: View {
    let title: String
    let subtitle: String
    
    var body: some View {
      Text(title)
        .font(.custom(.bold, size: 36))
        .padding(.top, 10)
      
      Text(subtitle)
        .font(.custom(.regular, size: 17))
        .lineSpacing(5)
        .padding(.bottom, 10)
    }
  }
}
