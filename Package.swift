// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nocilla",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "Nocilla", targets: ["Nocilla"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "Nocilla",
            dependencies: [

            ],
            path: "Nocilla",
            publicHeadersPath: "public"
        )
    ]
)

