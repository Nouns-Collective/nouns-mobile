// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright (C) 2022  <name of author>
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
    name: "BuildTools",
    dependencies: [
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.44.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.42.0"),
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "5.4.0"),
    ]
)
