// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.44.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.25.0"),
    ]
)
