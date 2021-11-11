//
//  NounderActivitiesView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Services
import UIComponents

struct NounderActivitiesView: View {
  @Binding var isPresented: Bool
  
  let domain: String
  
  var body: some View {
    ZStack {
      WarmGreydient()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          Text("Activity")
            .font(Font.custom(.bold, relativeTo: .title))
          Text(domain)
            .font(Font.custom(.regular, relativeTo: .subheadline))
            .opacity(0.75)
            .padding(.bottom, 40)
          
          ForEach(0..<5) { _ in
            PlainCell {
              VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center) {
                  Label("Approved", systemImage: "checkmark")
                    .contained(textColor: .white, backgroundColor: Color(uiColor: UIColor.systemBlue))
                    .labelStyle(.titleAndIcon(spacing: 3))
                    .font(Font.custom(.medium, relativeTo: .footnote))
                  Spacer()
                  Text("Proposal 14 • Passed")
                    .font(Font.custom(.medium, relativeTo: .body))
                    .opacity(0.5)
                }
                
                Text("Brave Sponsored Takeover during NFT NYC")
                  .fontWeight(.semibold)
              }
            }
          }
        }.padding()
          .padding(.top, 20)
      }
    }
  }
}

struct NounderActivitiesSheet_Previews: PreviewProvider {
  static var previews: some View {
    NounderActivitiesView(isPresented: .constant(true), domain: "bob.eth")
  }
}
