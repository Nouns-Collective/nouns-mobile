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
