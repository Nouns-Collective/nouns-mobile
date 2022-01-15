//
//  ProfileActivityFeed.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounActivityFeed: View {
  @StateObject var viewModel: ViewModel
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays the owner token.
        Text(viewModel.title)
          .lineLimit(1)
          .font(.custom(.bold, size: 36))
          .truncationMode(.middle)
        
        VPageGrid(viewModel.votes, columns: gridLayout, loadMoreAction: {
          // load next activities batch.
          await viewModel.fetchActivity()
          
        }, placeholder: {
          // An activity indicator while loading votes from the network.
          ActivityPlaceholder(count: 4)
          
        }, content: {
          ActivityRow(viewModel: .init(vote: $0))
        })
      }
      .padding()
    }
    .frame(maxWidth: .infinity)
    .emptyPlaceholder(when: viewModel.isEmpty, view: {
      ActivityFeedEmptyView(viewModel: viewModel)
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
            .redacted(style: .gray)
            .clipShape(Capsule())
          
          Spacer()
          
          Text("Loading - Loading")
            .foregroundColor(Color.componentNounsBlack)
            .font(Font.custom(.medium, relativeTo: .footnote))
            .opacity(0.5)
            .redacted(style: .skeleton)
        }
        
        VStack(alignment: .leading, spacing: 8) {
          Group {
            Text("Lorem ipsum dolor sit amet, consectetur")
            Text("Lorem ipsum dolor sit amet")
          }
          .redacted(style: .skeleton)
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
        Text(viewModel.title)
          .lineLimit(1)
          .font(.custom(.bold, size: 36))
          .truncationMode(.middle)
        
        Spacer()
        
        Text(R.string.activity.emptyState())
            .font(.custom(.medium, relativeTo: .headline))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .opacity(0.6)
        
        Spacer()
      }
      .padding()
    }
  }
}
