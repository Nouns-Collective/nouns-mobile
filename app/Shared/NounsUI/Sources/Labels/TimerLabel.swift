// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

/// A label for user interface items, consisting of
/// a timer with a countdown to the date given.
public struct TimerLabel: View {
    @State private var now = Date()
    private let until: Date
    
    init(until: Date) {
        self.until = until
    }
    
    public var body: some View {
        HStack {
            Image.timeleft
            VStack(alignment: .leading) {
                
                Text(countdown)
                    .font(.custom(.bold, relativeTo: .caption))
                    .multilineTextAlignment(.leading)
                    
                Text("Remaining")
                    .font(.custom(.regular, relativeTo: .caption).monospacedDigit())
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.now = Date()
            }
        }
    }
    
    var countdown: String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(
            [.hour, .minute, .second],
            from: now,
            to: until)
        
        return String(format: "%dh %d %ds",
                      components.hour ?? 0,
                      components.minute ?? 0,
                      components.second ?? 0)
    }
}
