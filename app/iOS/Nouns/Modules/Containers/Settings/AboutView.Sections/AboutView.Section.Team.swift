// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Krishna Satyanarayana
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
import Rswift

struct TeamInfoSection: View {

  struct TeamMember: Identifiable {
    let id: String
    let image: Rswift.ImageResource
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
