// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NounsUI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NounsUI",
            targets: ["NounsUI"]),
    ],
    dependencies: [
      .package(
        name: "Introspect",
        url: "https://github.com/siteline/SwiftUI-Introspect.git",
        from: "0.1.2"
      )
    ],
    targets: [
        .target(
            name: "NounsUI",
            dependencies: ["Introspect"],
            path: "Sources",
            resources: [.process("Resources/Fonts")]
        ),
        .testTarget(
            name: "NounsUITests",
            dependencies: ["NounsUI"],
            path: "Tests"
        ),
    ]
)
