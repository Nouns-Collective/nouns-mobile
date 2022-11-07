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

import Foundation

public enum AnalyticsEvent {
  public enum Screen: String {
    case onboarding = "OnboardingView"
    case explore = "ExploreExperience"
    case create = "CreateExperience"
    case about = "AboutView"
    case auctionNounProfile = "NounProfileInfo_Auction"
    case settledNounProfile = "NounProfileInfo_Settled"
    case nounCreator = "NounCreator"
    case offchainNounProfile = "OffChainNounProfile"
    case auctionInfo = "AuctionInfo"
    case settings = "SettingsView"
    case proposals = "ProposalFeedView"
    case appIcon = "AppIconStore"
  }

  public enum Event: String {
    case shakeToRandomize = "shake_to_randomize"
    case saveOffchainNoun = "save_offchain_noun"
    case shareOffchainNoun = "share_offchain_noun"
    case viewNounProfile = "view_noun_profile"
    case viewProposal = "view_proposal"
    case requestNotificationPermission = "request_notification_permission"
    case setNotificationPermission = "set_notification_permission"
    case setNewNounNotificationPermission = "set_new_noun_notification_permission"
    case setAlternateAppIcon = "set_alternate_app_icon"
    case openAppFromWidget = "open_app_from_widget"
    
    case openMadhappyAd = "open_madhappy_ad"
    case openMadhappyWebsite = "open_madhappy_website"
  }
}
