// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
    )
  ],
  targets: [
    .target(
      name: "Services",
      dependencies: ["web3.swift"],
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
