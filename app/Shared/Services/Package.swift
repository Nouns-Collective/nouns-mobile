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
    targets: [
        .target(
            name: "Services",
            dependencies: [],
            path: "Sources",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services"],
            path: "Tests",
            resources: [.process("Fixtures/Resources")]),
    ]
)
