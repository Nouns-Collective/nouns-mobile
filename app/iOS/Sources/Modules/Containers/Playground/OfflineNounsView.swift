//
//  OfflineNounsView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import UIComponents

struct OfflineNounsView: View {
  @Namespace var ns
  
  @Environment(\.managedObjectContext) var context
  
  @FetchRequest(
    entity: OfflineNoun.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \OfflineNoun.createdDate, ascending: false)
    ]
  ) var nouns: FetchedResults<OfflineNoun>
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 16) {
          ForEach(nouns, id: \.self) { noun in
            OfflineNounCard(animation: ns, noun: noun)
              .id(noun.id)
              .matchedGeometryEffect(id: "noun-\(noun.id)", in: ns)
          }
        }
        .softNavigationTitle(R.string.create.title(), rightAccessory: {
          // Dismiss About Nouns.wtf
          SoftButton(text: "New", largeAccessory: { Image.new }, action: {
            //
          })
        })
      }
      .background(Gradient.freshMint)
      .ignoresSafeArea()
    }
  }
}

struct OfflineNounsView_Previews: PreviewProvider {
  static var previews: some View {
    OfflineNounsView()
  }
}
