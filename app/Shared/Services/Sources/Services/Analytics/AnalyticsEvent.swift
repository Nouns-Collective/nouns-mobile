//
//  AnalyticsEvent.swift
//  
//
//  Created by Krishna Satyanarayana on 2022-04-20.
//

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
    case setNounOClockNotificationPermission = "set_noun_oclock_notification_permission"
    case setNewNounNotificationPermission = "set_new_noun_notification_permission"
    case setAlternateAppIcon = "set_alternate_app_icon"
    case openAppFromWidget = "open_app_from_widget"
  }
}
