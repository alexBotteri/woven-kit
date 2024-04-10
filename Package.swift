// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "woven-kit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "WovenUI", 
            targets: ["WovenUI"]
        ),
        .library(
            name: "WovenHelpers",
            targets: ["WovenHelpers"]
        )
    ],
    targets: [
        .target(name: "WovenUI"),
        .target(name: "WovenHelpers")
    ]
)
