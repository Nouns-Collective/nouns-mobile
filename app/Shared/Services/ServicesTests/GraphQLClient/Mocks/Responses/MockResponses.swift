//
//  MockResponses.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-21.
//

import Foundation
import Services
import Apollo

struct MockResponses {
  static func mockNounsList() -> NounsListQuery.Data {
    return NounsListQuery.Data(nouns:
                                [
                                  NounsListQuery.Data.Noun(id: GraphQLID("1"),
                                                           seed: NounsListQuery.Data.Noun.Seed(background: "0", body: "1", accessory: "2", head: "3", glasses: "4"),
                                                           owner: NounsListQuery.Data.Noun.Owner(id: GraphQLID("7"))),
                                  NounsListQuery.Data.Noun(id: GraphQLID("2"),
                                                           seed: NounsListQuery.Data.Noun.Seed(background: "0", body: "1", accessory: "2", head: "3", glasses: "4"),
                                                           owner: NounsListQuery.Data.Noun.Owner(id: GraphQLID("8"))),
                                  NounsListQuery.Data.Noun(id: GraphQLID("3"),
                                                           seed: NounsListQuery.Data.Noun.Seed(background: "0", body: "1", accessory: "2", head: "3", glasses: "4"),
                                                           owner: NounsListQuery.Data.Noun.Owner(id: GraphQLID("9"))),
                                  NounsListQuery.Data.Noun(id: GraphQLID("4"),
                                                           seed: NounsListQuery.Data.Noun.Seed(background: "0", body: "1", accessory: "2", head: "3", glasses: "4"),
                                                           owner: NounsListQuery.Data.Noun.Owner(id: GraphQLID("10"))),
                                  NounsListQuery.Data.Noun(id: GraphQLID("5"),
                                                           seed: NounsListQuery.Data.Noun.Seed(background: "0", body: "1", accessory: "2", head: "3", glasses: "4"),
                                                           owner: NounsListQuery.Data.Noun.Owner(id: GraphQLID("11"))),
                                  NounsListQuery.Data.Noun(id: GraphQLID("6"),
                                                           seed: NounsListQuery.Data.Noun.Seed(background: "0", body: "1", accessory: "2", head: "3", glasses: "4"),
                                                           owner: NounsListQuery.Data.Noun.Owner(id: GraphQLID("12")))
                                ]
                              )
  }
}
