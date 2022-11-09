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
import SpriteKit

struct MadhappyBanner: View {
  
  @Binding var isBottomSheetPresented: Bool
  
  static func shouldShowBanner(currentDate: Date) -> Bool {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = .init(identifier: "America/Los_Angeles") ?? .current

    // November 28, 2022 - 9:00 AM PDT
    let startDateComponents = DateComponents(year: 2022, month: 11, day: 28, hour: 9, minute: 0, second: 0)

    // November 29, 2022 - 9:00 AM PDT
    let endDateComponents = DateComponents(year: 2022, month: 11, day: 29, hour: 9, minute: 0, second: 0)

    guard let startDate = calendar.date(from: startDateComponents),
          let endDate = calendar.date(from: endDateComponents) else {
      return false
    }

    return (startDate...endDate).contains(currentDate)
  }
    
  var body: some View {
    TimelineView(.periodic(from: .now, by: 2)) { context in
      BannerView(now: context.date)
    }
    .onTapGesture {
      AppCore.shared.analytics.logEvent(withEvent: .viewMadhappyAd, parameters: nil)
      isBottomSheetPresented.toggle()
    }
  }
  
  struct BannerView: View {
    
    private func randomTime() -> Double {
      return Double.random(in: 0...1)
    }
    
    fileprivate static let maxOffset: CGFloat = -30
    
    private let madhappyNoun1: TalkingNoun = {
      let talkingNoun = TalkingNoun(seed: .init(background: 4, glasses: 3, head: 76, body: 6, accessory: 11))
      talkingNoun.eyes.animationSpeed = .fast
      talkingNoun.eyes.blinkOnly = false
      return talkingNoun
    }()
    
    private let madhappyNoun2: TalkingNoun = {
      let talkingNoun = TalkingNoun(seed: .init(background: 6, glasses: 7, head: 184, body: 22, accessory: 31))
      talkingNoun.eyes.animationSpeed = .fast
      talkingNoun.eyes.blinkOnly = false
      return talkingNoun
    }()
    
    private let madhappyNoun3: TalkingNoun = {
      let talkingNoun = TalkingNoun(seed: .init(background: 11, glasses: 14, head: 87, body: 14, accessory: 31))
      talkingNoun.eyes.animationSpeed = .fast
      talkingNoun.eyes.blinkOnly = false
      return talkingNoun
    }()
    
    private let madhappyNoun4: TalkingNoun = {
      let talkingNoun = TalkingNoun(seed: .init(background: 2, glasses: 7, head: 174, body: 2, accessory: 19))
      talkingNoun.eyes.animationSpeed = .fast
      talkingNoun.eyes.blinkOnly = false
      return talkingNoun
    }()
    
    private let nouns: [TalkingNoun]
    
    @State private var isNounPresented: Bool = true
    
    @State private var presentedNoun: Int = 0
    
    let now: Date
    
    init(now: Date) {
      self.now = now
      self.nouns = [madhappyNoun1, madhappyNoun2, madhappyNoun3, madhappyNoun4]
    }
    
    var body: some View {
      ZStack(alignment: .topLeading) {
        HStack {
          ForEach(0..<nouns.count, id: \.self) { index in
            SpriteView(scene: nouns[index], options: [.allowsTransparency])
              .frame(width: 45, height: 45)
              .offset(y: presentedNoun == index ? MadhappyBanner.BannerView.maxOffset : 0)
              .animation(.spring(), value: presentedNoun)
            
            if index < (nouns.count - 1) {
              Spacer()
            }
          }
        }
        .padding(.horizontal)
        
        PlainCell {
          HStack(alignment: .center) {
            Text(R.string.madhappy.title())
              .font(.custom(.medium, relativeTo: .subheadline))
            
            Spacer()
            
            Image.smArrowOut
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 16, height: 28, alignment: .center)
            
          }
          .padding()
        }
      }
      .onChange(of: now) { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + randomTime()) {
          self.toggleNoun()
        }
      }
    }
    
    private func toggleNoun() {
      presentedNoun = Int.random(in: 0..<nouns.count)
    }
  }
}
