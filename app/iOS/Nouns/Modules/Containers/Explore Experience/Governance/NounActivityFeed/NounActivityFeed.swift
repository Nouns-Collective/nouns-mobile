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
import Services

struct NounActivityFeed: View {
  @StateObject var viewModel: ViewModel
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 8),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays the owner token.
        ENSText(token: viewModel.owner)
          .font(.custom(.bold, relativeTo: .title2))
        
        VPageGrid(viewModel.votes, columns: gridLayout, spacing: 10, isLoading: viewModel.isLoading, shouldLoadMore: viewModel.shouldLoadMore, loadMoreAction: {
          // load next activities batch.
          await viewModel.fetchActivity()
          
        }, placeholder: {
          // An activity indicator while loading votes from the network.
          ActivityPlaceholder(count: 4)
          
        }, content: {
          ActivityRow(viewModel: .init(vote: $0))
        })
        
        if viewModel.failedToLoadMore {
          TryAgain(
            message: R.string.activity.errorLoadMoreTitle(),
            buttonText: R.string.shared.tryAgain(),
            retryAction: {
              Task {
                await viewModel.fetchActivity()
              }
            }
          )
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.bottom, 80)
        }
      }
      .padding()
    }
    .frame(maxWidth: .infinity)
    .emptyPlaceholder(when: viewModel.isEmpty && !viewModel.failedToLoadMore, view: {
      ActivityFeedEmptyView(viewModel: viewModel)
    })
    .emptyPlaceholder(when: viewModel.isEmpty && viewModel.failedToLoadMore, view: {
      ActivityFeedErrorView(viewModel: viewModel)
    })
    .task {
      await viewModel.fetchActivity()
    }
  }
}

struct ActivityPlaceholderRow: View {
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .center) {
          ChipLabel("Loading", state: .pending)
            .redactable(style: .gray)
            .clipShape(Capsule())
          
          Spacer()
          
          Text("Loading - Loading")
            .foregroundColor(Color.componentNounsBlack)
            .font(Font.custom(.medium, relativeTo: .footnote))
            .opacity(0.5)
            .redactable(style: .skeleton)
        }
        
        VStack(alignment: .leading, spacing: 8) {
          Group {
            Text("Lorem ipsum dolor sit amet, consectetur")
            Text("Lorem ipsum dolor sit amet")
          }
          .redactable(style: .skeleton)
        }
        .font(Font.custom(.medium, relativeTo: .body))
        .padding(.top, 8)
        
      }.padding()
    }
  }
}

extension NounActivityFeed {
  
  /// A view to display when there are no votes placed by the owner of the noun
  struct ActivityFeedEmptyView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays the owner token.
        ENSText(token: viewModel.owner)
          .font(.custom(.bold, relativeTo: .title2))
        
        Spacer()
        
        Text(R.string.activity.emptyState())
            .font(.custom(.regular, relativeTo: .footnote))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .opacity(0.6)
        
        Spacer()
      }
      .padding()
    }
  }
  
  /// A view to display when there was an error while retrieving a noun's activity feed, resulting in 0 activities in the view model
  struct ActivityFeedErrorView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays the owner token.
        ENSText(token: viewModel.owner)
          .font(.custom(.bold, relativeTo: .title2))
        
        Spacer()
        
        TryAgain(
          message: R.string.activity.errorEmptyTitle(),
          buttonText: R.string.shared.tryAgain(),
          retryAction: {
            Task {
              await viewModel.fetchActivity()
            }
          }
        )
        .frame(maxWidth: .infinity, alignment: .center)
        
        Spacer()
      }
      .padding()
    }
  }
}
