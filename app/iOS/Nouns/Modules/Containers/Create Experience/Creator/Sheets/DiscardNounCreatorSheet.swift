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
import NounsUI

/// Dialog to delete offline Nouns.
extension NounCreator {
  
  /// A wrapper discard sheet, showing either a sheet to discard edit progress or
  /// creation progress based on the edit state of the view
  struct DiscardNounSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      if viewModel.isEditing {
        DiscardNounEditSheet(viewModel: viewModel)
      } else {
        DiscardNounCreationSheet(viewModel: viewModel)
      }
    }
  }
  
  /// A sheet presented when the user tries to cancel their progress
  /// while creating a new noun
  struct DiscardNounCreationSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var bottomSheetManager: BottomSheetManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.nounDeleteDialog.title()
      ) {
        VStack(alignment: .leading) {
          Text(R.string.nounDeleteDialog.message())
            .font(.custom(.regular, relativeTo: .subheadline))
            .lineSpacing(6)
            .padding(.bottom, 20)
          
          SoftButton(
            text: R.string.nounDeleteDialog.nounDeleteAction(),
            largeAccessory: { Image.trash },
            color: Color.componentNounRaspberry,
            action: {
              bottomSheetManager.closeBottomSheet()
              dismiss()
            })
            .controlSize(.large)
          
          SoftButton(
            text: R.string.nounDeleteDialog.nounCancelAction(),
            largeAccessory: { Image.later },
            action: {
              withAnimation {
                viewModel.setMode(to: .creating)
              }
            })
            .controlSize(.large)
        }
      }
      .padding(.bottom, 4)
    }
  }
  
  /// A sheet presented when the user tries to cancel their progress
  /// while editing a pre-existing offline noun
  struct DiscardNounEditSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var bottomSheetManager: BottomSheetManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.nounDiscardEditDialog.title()
      ) {
        VStack(alignment: .leading) {
          Text(R.string.nounDiscardEditDialog.message())
            .font(.custom(.regular, relativeTo: .subheadline))
            .lineSpacing(6)
            .padding(.bottom, 20)
          
          SoftButton(
            text: R.string.nounDiscardEditDialog.nounDeleteAction(),
            largeAccessory: { Image.trash },
            color: Color.componentNounRaspberry,
            action: {
              bottomSheetManager.closeBottomSheet()
              dismiss()
            })
            .controlSize(.large)
          
          SoftButton(
            text: R.string.nounDiscardEditDialog.nounCancelAction(),
            largeAccessory: { Image.later },
            action: {
              withAnimation {
                viewModel.setMode(to: .creating)
              }
            })
            .controlSize(.large)
        }
      }
      .padding(.bottom, 4)
    }
  }
}
