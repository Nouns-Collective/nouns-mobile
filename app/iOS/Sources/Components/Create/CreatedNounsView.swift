//
//  CreatedNounsView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import Combine

/// A view to display a list of all the nouns that the user has created
struct CreatedNounsView: View {
  @Environment(\.managedObjectContext) var context

  @FetchRequest(
    entity: OfflineNoun.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \OfflineNoun.createdDate, ascending: false)
    ]
  ) var nouns: FetchedResults<OfflineNoun>
  
  var body: some View {
    Text("Created Nouns: \(nouns.count)")
  }
}

struct CreatedNounsView_Previews: PreviewProvider {
  static var previews: some View {
    CreatedNounsView()
  }
}
