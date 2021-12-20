//
//  AboutView.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct GovernanceInfoSection: View {
  @Binding var isAboutNounsPresented: Bool
  
  private let localize = R.string.about.self
  
  var body: some View {
    VStack {
      PlainCell {
        HStack(alignment: .center) {
          
          Label(title: {
            Text(localize.treasury())
              .font(.custom(.medium, size: 13))
            
          }, icon: {
            Image.nounLogo
              .resizable()
              .frame(width: 9.43, height: 12)
          })
            .background(Gradient.mangoChunks)
            .clipShape(Capsule())
            .frame(width: 95, height: 23)
          
          Spacer()
          
          Label(title: {
            Text("15,239")
              .font(.custom(.bold, size: 24))
            
          }, icon: {
            Image.eth
              .resizable()
              .frame(width: 20, height: 20)
          })
        }.padding()
      }
      
      SoftButton(
        text: localize.learnMore(),
        icon: { Image.web },
        smallAccessory: { Image.smArrowOut },
        action: {
          withAnimation {
            isAboutNounsPresented.toggle()
          }
        })
        .controlSize(.large)
    }
  }
}
