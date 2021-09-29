// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "app",
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.25.0"),
    ]
)
