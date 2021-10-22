// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AuctionSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription Auction {
      auctions(orderBy: settled, first: 1) {
        __typename
        id
        amount
        startTime
        endTime
        settled
      }
    }
    """

  public let operationName: String = "Auction"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("auctions", arguments: ["orderBy": "settled", "first": 1], type: .nonNull(.list(.nonNull(.object(Auction.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(auctions: [Auction]) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "auctions": auctions.map { (value: Auction) -> ResultMap in value.resultMap }])
    }

    public var auctions: [Auction] {
      get {
        return (resultMap["auctions"] as! [ResultMap]).map { (value: ResultMap) -> Auction in Auction(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Auction) -> ResultMap in value.resultMap }, forKey: "auctions")
      }
    }

    public struct Auction: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Auction"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("amount", type: .nonNull(.scalar(String.self))),
          GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
          GraphQLField("endTime", type: .nonNull(.scalar(String.self))),
          GraphQLField("settled", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, amount: String, startTime: String, endTime: String, settled: Bool) {
        self.init(unsafeResultMap: ["__typename": "Auction", "id": id, "amount": amount, "startTime": startTime, "endTime": endTime, "settled": settled])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The Noun's ERC721 token id
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The current highest bid amount
      public var amount: String {
        get {
          return resultMap["amount"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "amount")
        }
      }

      /// The time that the auction started
      public var startTime: String {
        get {
          return resultMap["startTime"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "startTime")
        }
      }

      /// The time that the auction is scheduled to end
      public var endTime: String {
        get {
          return resultMap["endTime"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "endTime")
        }
      }

      /// Whether or not the auction has been settled
      public var settled: Bool {
        get {
          return resultMap["settled"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "settled")
        }
      }
    }
  }
}

public final class NounsListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query NounsList($skip: Int, $first: Int) {
      nouns(skip: $skip, first: $first) {
        __typename
        id
        seed {
          __typename
          background
          body
          accessory
          head
          glasses
        }
        owner {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "NounsList"

  public var skip: Int?
  public var first: Int?

  public init(skip: Int? = nil, first: Int? = nil) {
    self.skip = skip
    self.first = first
  }

  public var variables: GraphQLMap? {
    return ["skip": skip, "first": first]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("nouns", arguments: ["skip": GraphQLVariable("skip"), "first": GraphQLVariable("first")], type: .nonNull(.list(.nonNull(.object(Noun.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(nouns: [Noun]) {
      self.init(unsafeResultMap: ["__typename": "Query", "nouns": nouns.map { (value: Noun) -> ResultMap in value.resultMap }])
    }

    public var nouns: [Noun] {
      get {
        return (resultMap["nouns"] as! [ResultMap]).map { (value: ResultMap) -> Noun in Noun(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Noun) -> ResultMap in value.resultMap }, forKey: "nouns")
      }
    }

    public struct Noun: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Noun"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("seed", type: .object(Seed.selections)),
          GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, seed: Seed? = nil, owner: Owner) {
        self.init(unsafeResultMap: ["__typename": "Noun", "id": id, "seed": seed.flatMap { (value: Seed) -> ResultMap in value.resultMap }, "owner": owner.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The Noun's ERC721 token id
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The seed used to determine the Noun's traits
      public var seed: Seed? {
        get {
          return (resultMap["seed"] as? ResultMap).flatMap { Seed(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "seed")
        }
      }

      /// The owner of the Noun
      public var owner: Owner {
        get {
          return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "owner")
        }
      }

      public struct Seed: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Seed"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("background", type: .nonNull(.scalar(String.self))),
            GraphQLField("body", type: .nonNull(.scalar(String.self))),
            GraphQLField("accessory", type: .nonNull(.scalar(String.self))),
            GraphQLField("head", type: .nonNull(.scalar(String.self))),
            GraphQLField("glasses", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(background: String, body: String, accessory: String, head: String, glasses: String) {
          self.init(unsafeResultMap: ["__typename": "Seed", "background": background, "body": body, "accessory": accessory, "head": head, "glasses": glasses])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The background index
        public var background: String {
          get {
            return resultMap["background"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "background")
          }
        }

        /// The body index
        public var body: String {
          get {
            return resultMap["body"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "body")
          }
        }

        /// The accessory index
        public var accessory: String {
          get {
            return resultMap["accessory"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "accessory")
          }
        }

        /// The head index
        public var head: String {
          get {
            return resultMap["head"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "head")
          }
        }

        /// The glasses index
        public var glasses: String {
          get {
            return resultMap["glasses"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "glasses")
          }
        }
      }

      public struct Owner: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Account"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Account", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// An Account is any address that holds any amount of Nouns, the id used is the blockchain address.
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}
