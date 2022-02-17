// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Tools",
  platforms: [.macOS(.v12)],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-argument-parser",
      from: "1.0.0"
    ),
  ],
  targets: [
    .executableTarget(
      name: "Tools",
      dependencies: ["ToolsCore"],
      path: "Sources/Tools"
    ),
    .target(
      name: "ToolsCore",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      path: "Sources/ToolsCore",
      resources: [.process("Resources")]
    ),
    .testTarget(
      name: "ToolsTests",
      dependencies: ["Tools"],
      path: "Tests"
    ),
  ]
)
