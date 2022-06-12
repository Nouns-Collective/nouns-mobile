// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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

import PackageDescription

let package = Package(
  name: "Services",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "Services",
      targets: ["Services"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/argentlabs/web3.swift",
      from: "0.7.0"
    ),
    .package(
      name: "Firebase",
      url: "https://github.com/firebase/firebase-ios-sdk",
      from: "8.14.0"
    )
  ],
  targets: [
    .target(
      name: "Services",
      dependencies: [
        "web3.swift",
        .product(name: "FirebaseAnalytics", package: "Firebase"),
        .product(name: "FirebaseCrashlytics", package: "Firebase"),
        .product(name: "FirebaseMessaging", package: "Firebase"),
      ],
      path: "Sources",
      resources: [.process("Resources")]
    ),
    .testTarget(
      name: "ServicesTests",
      dependencies: ["Services"],
      path: "Tests",
      resources: [
        .process("Fixtures/Resources"),
        .process("Nouns/OnChainTheGraphStore/Fixtures"),
        .process("Nouns/NounComposer/Fixtures"),
        .process("ENS/Fixtures"),
      ]),
  ]
)
