// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: [],
            path: "Sources",
            resources: [.process("Resources/Fonts")]
        ),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"]),
    ]
)
