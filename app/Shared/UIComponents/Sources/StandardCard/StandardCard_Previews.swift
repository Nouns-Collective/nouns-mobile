//
//  StandardCard_Previews.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-30.
//

import SwiftUI

struct StandardCard_Previews: PreviewProvider {
    struct PreviewView: View {
        init() {
            UIComponents.configure()
        }
        
        var body: some View {
            StandardCard(header: "Header", accessory: {
                Image.mdArrowCorner
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
            }, media: {
                Color.gray
                    .frame(height: 400)
            }, content: {
                HStack {
                    CompoundLabel(Text("Some Text"), icon: Image.currentBid, caption: "Current Bid")
                    
                    Spacer()
                    
                    CompoundLabel(Text("Some Text"), icon: Image.currentBid, caption: "Current Bid")
                    
                    Spacer()
                }
                .padding(.top, 20)
            })
            .headerStyle(.large)
            .padding()
        }
    }
    
    struct PreviewSmallCardView: View {
        init() {
            UIComponents.configure()
        }
        
        var body: some View {
            StandardCard(header: "Header", accessory: {
                Image.mdArrowCorner
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16, alignment: .center)
            }, media: {
                Color.gray
                    .frame(height: 400)
            }, content: {
                SafeLabel("140.00", icon: Image.eth)
                    .padding(.top, 8)
            })
            .headerStyle(.small)
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewView()
        PreviewSmallCardView()
    }
}
