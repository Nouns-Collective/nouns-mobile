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

struct StandardCard_Previews: PreviewProvider {
    struct PreviewView: View {
        init() {
          NounsUI.configure()
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
                  CompoundLabel({ Text("Some Text") }, icon: Image.currentBid, caption: "Current Bid")
                    
                    Spacer()
                    
                  CompoundLabel({ Text("Some Text") }, icon: Image.currentBid, caption: "Current Bid")
                    
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
          NounsUI.configure()
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
