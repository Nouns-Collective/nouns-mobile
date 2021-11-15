//
//  TimerLabel.swift
//  
//
//  Created by Ziad Tamim on 15.11.21.
//

import SwiftUI

/// A label for user interface items, consisting of
/// a timer with a countdown to the date given.
public struct TimerLabel: View {
    @State private var now: Date = Date()
    private let until: Date
    
    init(until: Date) {
        self.until = until
    }
    
    public var body: some View {
        HStack {
            Image.timeleft
            VStack(alignment: .leading) {
                
                Text(countdown)
                    .font(.custom(.bold, relativeTo: .footnote))
                    .multilineTextAlignment(.leading)
                    
                Text("Remaining")
                    .font(.custom(.regular, relativeTo: .footnote).monospacedDigit())
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
