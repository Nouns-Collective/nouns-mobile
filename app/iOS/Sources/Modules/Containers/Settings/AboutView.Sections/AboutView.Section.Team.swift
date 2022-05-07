//
//  AboutView.Section.Team.swift
//  Nouns
//
//  Created by Krishna Satyanarayana on 2022-04-30.
//

import SwiftUI
import UIComponents
import Rswift

struct TeamInfoSection: View {

  struct TeamMember: Identifiable {
    let id: String
    let image: ImageResource
  }

  let teamMembers = [
    TeamMember(id: "robjama", image: R.image.roblehNoun),
    TeamMember(id: "mrkrishsatya", image: R.image.krishNoun),
    TeamMember(id: "matthewpacione", image: R.image.mattNoun),
    TeamMember(id: "shawnrcole", image: R.image.shawnNoun),
    TeamMember(id: "ziad_tamim", image: R.image.ziadNoun),
    TeamMember(id: "mohams2001", image: R.image.moNoun),
    TeamMember(id: "_arslanc", image: R.image.arslanNoun)
  ]

  /// A boolean to load the Nouns App website using a browser.
  @State private var isNounsAppWebsitePresented = false

  /// The team member's Twitter profile to load in a browser.
  @State private var selectedTeamMember: TeamMember?

  /// Holds a reference to the localized text.
  private let localize = R.string.team.self

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {

      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())

      ForEach(teamMembers) { teamMember in
        OutlineButton(
          text: "@\(teamMember.id)",
          largeIcon: { Image(teamMember.image.name) },
          smallAccessory: { Image.smArrowOut },
          action: {
            selectedTeamMember = teamMember
          }
        )
        .controlSize(.large)
      }

      SoftButton(
        text: localize.websiteLink(),
        smallAccessory: { Image.mdArrowRight },
        action: { isNounsAppWebsitePresented.toggle() }
      )
      .controlSize(.large)
    }
    .fullScreenCover(isPresented: $isNounsAppWebsitePresented) {
      if let url = URL(string: localize.websiteUrl()) {
        Safari(url: url)
      }
    }
    .fullScreenCover(item: $selectedTeamMember, onDismiss: {
      selectedTeamMember = nil
    }, content: { teamMember in
      if let url = URL(string: localize.twitterProfileUrl(teamMember.id)) {
        Safari(url: url)
      }
    })
  }
}
