// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MTAFeed",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "MTAFeed",
            targets: ["MTAFeed"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MTAFeed",
            dependencies: [.product(name: "SwiftProtobuf", package: "swift-protobuf")]),
        .testTarget(
            name: "MTAFeedTests",
            dependencies: ["MTAFeed"]),
    ]
)
