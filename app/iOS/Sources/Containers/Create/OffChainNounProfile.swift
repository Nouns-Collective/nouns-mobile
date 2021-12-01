//
//  OffChainNounProfile.swift
//  Nouns
//
//  Created by Ziad Tamim on 28.11.21.
//

import SwiftUI
import UIComponents

struct OffChainNounProfile: View {
  @Binding var isPresented: Bool
  let noun: OfflineNoun
  @State private var isMoreActionPresented = false
  @State private var isDeleteActionPresented = false
  
  private var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMMM d, YYYY"
    return dateFormatter.string(from: noun.createdDate ?? Date())
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NounPuzzle(
        head: Image(nounTraitName: noun.head ?? ""),
        body: Image(nounTraitName: noun.body ?? ""),
        glass: Image(nounTraitName: noun.glasses ?? ""),
        accessory: Image(nounTraitName: noun.accessory ?? "")
      )
      
      // TODO: Use action sheet instead once built
      PlainCell {
        if !isMoreActionPresented {
          VStack(alignment: .leading, spacing: 20) {
              HStack(alignment: .top) {
                  Text(noun.name ?? "")
                      .font(.custom(.bold, size: 36))
                      .lineLimit(2)
                
                Spacer()
                
                SoftButton(
                  icon: { Image.xmark },
                  action: { isPresented.toggle() })
                    .padding(.top, 5)
              }
              
            VStack(spacing: 20) {
              InfoCell(
                text: R.string.createNounDialog.nounBirthdayLabel(dateString),
                icon: { Image.birthday })
              
              InfoCell(
                text: R.string.createNounDialog.ownerLabel(),
                icon: { Image.holder })
            }
            .padding(.bottom, 40)
            
            SoftButton(
              text: R.string.createNounDialog.actionShare(),
              largeAccessory: { Image.share },
              action: { },
              fill: [.width])
            
            SoftButton(
              text: R.string.offchainNounActions.title(),
              smallAccessory: { Image.mdArrowRight },
              action: {
                withAnimation {
                  isMoreActionPresented.toggle()
                }
              },
              fill: [.width])
          }
          .padding(16)
          .transition(.slide)
        } else {
          VStack(alignment: .leading, spacing: 10) {
            SoftButton(
              icon: { Image.back },
              action: {
                withAnimation {
                  isMoreActionPresented.toggle()
                }
              })
              .padding(.top, 5)
            
              HStack(alignment: .top) {
                  Text(R.string.offchainNounActions.title())
                      .font(.custom(.bold, size: 36))
                      .lineLimit(2)
              }
              
            SoftButton(
              text: R.string.offchainNounActions.play(),
              largeAccessory: { Image.playOutline },
              action: { },
              fill: [.width])
            
            SoftButton(
              text: R.string.offchainNounActions.edit(),
              largeAccessory: { Image.createOutline },
              action: {
                isMoreActionPresented.toggle()
              },
              fill: [.width])
            
            SoftButton(
              text: R.string.offchainNounActions.rename(),
              largeAccessory: { Image.rename },
              action: {
                isMoreActionPresented.toggle()
              },
              fill: [.width])
            
            SoftButton(
              text: R.string.offchainNounActions.delete(),
              largeAccessory: { Image.trash },
              color: Color.componentNounRaspberry,
              action: {
                withAnimation {
                  isDeleteActionPresented.toggle()
                }
              },
              fill: [.width])
          }
          .padding(16)
          .padding(.bottom, 20)
          .transition(.slide)
        }
      }
      .padding(.bottom, 4)
      .padding(.horizontal, 20)
    }
    .bottomSheet(isPresented: $isDeleteActionPresented, content: {
      DeleteOfflineNounDialog2(isDisplayed: $isDeleteActionPresented, noun: noun)
    })
    .background(gradient)
    .ignoresSafeArea()
  }
  
  private var gradient: some View {
    LinearGradient(
      colors: Gradient.allGradients()[Int(noun.background)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing)
  }
}
