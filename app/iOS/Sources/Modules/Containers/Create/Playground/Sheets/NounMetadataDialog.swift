////
////  NounMetadataDialog.swift
////  Nouns
////
////  Created by Mohammed Ibrahim on 2021-12-08.
////
//
//import SwiftUI
//import UIComponents
//
///// A dialog to present the current playground noun's name (as a text field to allow the user to edit),
///// infromation such as birth date, and action to save the noun
//struct NounMetadataDialog: View {
//  @State var nounName: String = ""
//  @Binding var isEditing: Bool
//  @Binding var isPresented: Bool
//  
//  var body: some View {
//    ActionSheet(
//      title: "Beets Battlestar Galactica",
//      isEditing: isEditing,
//      placeholder: R.string.createNounDialog.inputPlaceholder(),
//      text: $nounName
//    ) {
//      VStack(alignment: .leading) {
//        NounDialogContent()
//        NounDialogActions()
//      }
//    }
//    .padding(.bottom, 4)
//    .onAppear {
//      self.nounName = playgroundState.name
//    }
//    .onChange(of: nounName) { newValue in
//      store.dispatch(PlaygroundUpdateName(name: newValue))
//    }
//  }
//}
//
//// TODO: - Redux FormatterState(Flux) or Utility functions if taking more time to build.
//
/////
//struct NounDialogContent: View {
//  
//  private var dateString: String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone.current
//    dateFormatter.locale = NSLocale.current
//    dateFormatter.dateFormat = "MMMM d, YYYY"
//    return dateFormatter.string(from: Date())
//  }
//  
//  var body: some View {
//    VStack(spacing: 20) {
//      InfoCell(
//        text: R.string.createNounDialog.nounBirthdayLabel(dateString),
//        icon: { Image.birthday })
//      
//      InfoCell(
//        text: R.string.createNounDialog.ownerLabel(),
//        icon: { Image.holder })
//    }
//    .padding(.bottom, 40)
//  }
//}
//
/////
//struct NounDialogActions: View {
//  @Environment(\.dismiss) private var dismiss
//  @Environment(\.managedObjectContext) private var context
//  
//  var body: some View {
//    SoftButton(
//      text: R.string.createNounDialog.actionSave(),
//      largeAccessory: { Image.save },
//      action: {
//        if !playgroundState.name.isEmpty {
//          store.dispatch(PlaygroundCreateOfflineNounAction())
//          dismiss()
//        }
//      })
//      .controlSize(.large)
//  }
//}
