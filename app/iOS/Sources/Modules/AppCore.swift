//
//  AppCore.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import Combine
import Services

final class AppCore {
  static let shared = AppCore()
  
  let onChainNounsService: OnChainNounsService = TheGraphNounsProvider()
  let offChainNounsService: OffChainNounsService = CoreDataNounsProvider()
  
  /// Service responsible for handling Apple Push Notifications.
  lazy var messaging: Messaging = FirebaseMessagingProvider()
  
  lazy var settingsStore: SettingsStore = {
    UserDefaultsSettingsStore(messaging: messaging)
  }()
  
  /// The web3Client is abstracted out to a private property as it is re-used in both the Ethereum and ENS front-layer clients below.
  /// Views should only use `ethClient` and `ensNameService` to communicate with each respective part, as those protocols are not subject to change
  private lazy var web3Client: Web3Client = {
    do {
      return try Web3Client()
    } catch {
      fatalError("Couldn't instantiate the web3Client: \(error)")
    }
  }()

  lazy var ethClient: Ethereum = web3Client
  
  lazy var ensNameService: ENS = Web3ENSProvider(ethereumClient: web3Client.client)
  
  lazy var nounComposer: NounComposer = {
    do {
      return try OfflineNounComposer.default()
    } catch {
      fatalError("Couldn't instantiate the NounComposer: \(error)")
    }
  }()
}
