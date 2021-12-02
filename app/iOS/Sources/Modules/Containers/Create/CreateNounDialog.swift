//
//  DialogInput.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI
import UIComponents

/// TODO: Merge DeleteOfflineNounDialog2 & DeleteOfflineNounDialog and create a Destructive ActionSheet inside UICOmponents
struct DeleteOfflineNounDialog2: View {
  @Environment(\.presentationMode) private var presentationMode
  @Binding var isDisplayed: Bool
  var noun: OfflineNoun
  
  var body: some View {
    DialogNavigation(title: R.string.nounDeleteDialog.title()) {
      
      Text(R.string.nounDeleteDialog.message())
        .font(.custom(.regular, size: 17))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounDeleteAction(),
        largeAccessory: { Image.trash },
        color: Color.componentNounRaspberry,
        action: {
          withAnimation {
            PersistenceStore.shared.delete(noun)
            presentationMode.wrappedValue.dismiss()
          }
        },
        fill: [.width])
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounCancelAction(),
        largeAccessory: { Image.smAbsent },
        action: {
          withAnimation {
            isDisplayed.toggle()
          }
          
        },
        fill: [.width])
    }
    .padding(.bottom, 4)
  }
}

/// Dialog to delete offline Nouns.
struct DeleteOfflineNounDialog: View {
  @Environment(\.presentationMode) private var presentationMode
  @Binding var isDisplayed: Bool
  
  var body: some View {
    DialogNavigation(title: R.string.nounDeleteDialog.title()) {
      
      Text(R.string.nounDeleteDialog.message())
        .font(.custom(.regular, size: 17))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounDeleteAction(),
        largeAccessory: { Image.trash },
        color: Color.componentNounRaspberry,
        action: { presentationMode.wrappedValue.dismiss() },
        fill: [.width])
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounCancelAction(),
        largeAccessory: { Image.smAbsent },
        action: {
          withAnimation {
            isDisplayed.toggle()
          }
        },
        fill: [.width])
    }
    .padding(.bottom, 4)
  }
}

extension ActionSheet {
  
}
/*
 
 // TODO: Build an a navigation stack similar to the API below
 DialogNavigation(selection: $selection) {
       ActionSheet(text: "Something", pressAction: { selection = 1 } ) // Structure as what Label is doing `Configuration(title, content, Action)`
           .dialogAccessories(trailing: {
              // xmark
            })
           .tag(0)
           

      ActionSheet(text: "Back", pressAction: { selection = 0} )
           .dialogAccessories(leading: {
              // back button
            })
           .tag(1)
 }
 
 */
//DialogNavigation {
  // PreferenceKey in order to send the child view
  // to the parent, when the state is altered the new view is push into the stack.
  // ActionSheet1
  //
//}
  
/// Separate view
//TextFieldActionSheet($text, placeholder, content: {
//
//}, actions: {
//
//})
/// TODO: Build TextFieldActionSheet & ActionSheet
struct NounMetadataDialog: View {
  @ObservedObject var viewModel: PlaygroundViewModel
  @Binding var isEditing: Bool
  @Binding var isPresented: Bool
  
  var body: some View {
    DialogNavigation(
      title: "Beets Battlestar Galactica",
      isEditing: $isEditing,
      text: $viewModel.name,
      placeholder: "Name your noun!",
      trailing: {
        SoftButton(
          icon: { Image.xmark },
          action: { isPresented.toggle() })
        
      },
      content: {
        NounDialogContent()
        NounDialogActions(viewModel: viewModel)
      })
      .padding(.bottom, 4)
  }
}

// TODO: Redux FormatterState(Flux) or Utility functions if taking more time to build.

///
struct NounDialogContent: View {
  
  private var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMMM d, YYYY"
    return dateFormatter.string(from: Date())
  }
  
  var body: some View {
    VStack(spacing: 20) {
      InfoCell(
        text: R.string.createNounDialog.nounBirthdayLabel(dateString),
        icon: { Image.birthday })
      
      InfoCell(
        text: R.string.createNounDialog.ownerLabel(),
        icon: { Image.holder })
    }
    .padding(.bottom, 40)
  }
}

///
struct NounDialogActions: View {
  @Environment(\.presentationMode) private var presentationMode
  @Environment(\.managedObjectContext) private var context
  @ObservedObject var viewModel: PlaygroundViewModel
  
  var body: some View {
    SoftButton(
      text: R.string.createNounDialog.actionSave(),
      largeAccessory: { Image.save },
      action: {
        if !viewModel.name.isEmpty {
          PersistenceStore.shared.saveCreatedNoun(
            name: viewModel.name,
            glasses: AppCore.shared.nounComposer.glasses[viewModel.seed[0]].assetImage,
            head: AppCore.shared.nounComposer.heads[viewModel.seed[1]].assetImage,
            body: AppCore.shared.nounComposer.bodies[viewModel.seed[2]].assetImage,
            accessory: AppCore.shared.nounComposer.accessories[viewModel.seed[3]].assetImage,
            background: Int32(viewModel.seed[4]))
          
          presentationMode.wrappedValue.dismiss()
        }
      },
      fill: [.width])
  }
}

/// 
struct NounOptionsActionSheet: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    DialogNavigation(
      title: R.string.offchainNounActions.title(),
      leading: {
        
        SoftButton(
          icon: { Image.back },
          action: { isPresented.toggle() })
          .padding(.top, 5)
        
      },
      content: {
        
        SoftButton(
          text: R.string.offchainNounActions.play(),
          largeAccessory: { Image.playOutline },
          action: { },
          fill: [.width])
        
        SoftButton(
          text: R.string.offchainNounActions.edit(),
          largeAccessory: { Image.createOutline },
          action: { },
          fill: [.width])
        
        SoftButton(
          text: R.string.offchainNounActions.rename(),
          largeAccessory: { Image.rename },
          action: {
          },
          // TODO: Should be Removed. Low Priority
          fill: [.width])
        
        SoftButton(
          text: R.string.offchainNounActions.delete(),
          largeAccessory: { Image.trash },
          color: Color.componentNounRaspberry,
          action: { },
          fill: [.width])
      })
  }
}

struct NounOptionsActionSheet_Previews: PreviewProvider {
  static var previews: some View {
    Text("OffChain Noun Actions")
      .bottomSheet(isPresented: .constant(true)) {
        NounOptionsActionSheet(
          isPresented: .constant(true))
      }
  }
}
