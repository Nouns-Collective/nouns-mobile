//
//  EverydayNoun.swift
//  Everyday Noun Extension
//
//  Created by Ziad Tamim on 16.04.22.
//

import WidgetKit
import SwiftUI
import Services

struct Provider: TimelineProvider {
  
  func placeholder(in context: Context) -> LiveAuctionEntry {
    LiveAuctionEntry(date: Date(), seed: .default)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (LiveAuctionEntry) -> Void) {
    let entry = LiveAuctionEntry(date: Date(), seed: .default)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    Task {
      var auctionsEntries: [LiveAuctionEntry] = []
      
      do {
        
        let onChainNounsService = TheGraphOnChainNouns()
        
        for try await auction in onChainNounsService.liveAuctionStateDidChange() {
          let liveAuctionEntry = LiveAuctionEntry(date: .now, seed: auction.noun.seed)
          auctionsEntries.append(liveAuctionEntry)
          
          if let expiryDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date(timeIntervalSince1970: auction.endTime)) {
            let policy = TimelineReloadPolicy.after(expiryDate)
            let timeline = Timeline(entries: auctionsEntries, policy: policy)
            completion(timeline)
            
            break
          }
        }
        
      } catch {
        guard let refreshIntervalDate = Calendar.current.date(byAdding: .second, value: 3, to: .now) else {
          return
        }
        let policy = TimelineReloadPolicy.after(refreshIntervalDate)
        
        let timeline = Timeline(entries: auctionsEntries, policy: policy)
        completion(timeline)
      }
    }
  }
}

struct LiveAuctionEntry: TimelineEntry {
  let date: Date
  let seed: Seed
}

struct EverydayNounEntryView: View {
  var entry: Provider.Entry
  
  private let nounComposer = OfflineNounComposer.default()
  
  var body: some View {
    NounLayers(seed: entry.seed)
      .background(Color(hex: nounComposer.backgroundColors[entry.seed.background]))
      .widgetURL(URL(string: "nouns:///live-auction"))
      .environment(\.nounComposer, nounComposer)
  }
}

@main
struct EverydayNoun: Widget {
  let kind: String = "EverydayNoun"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      EverydayNounEntryView(entry: entry)
    }
    .configurationDisplayName(R.string.localizable.widget_display_name())
    .description(R.string.localizable.widget_description())
    .supportedFamilies([.systemSmall])
  }
}

struct EverydayNoun_Previews: PreviewProvider {
  static var previews: some View {
    EverydayNounEntryView(entry: LiveAuctionEntry(date: Date(), seed: .default))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
