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
