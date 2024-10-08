// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinkoffID",
    defaultLocalization: "ru",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "TinkoffID",
            targets: ["TinkoffID"]
        ),
    ],
    dependencies: [
        .package(url: "https://opensource.tbank.ru/mobile-tech/sslpinning.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "TinkoffID",
            dependencies: [
                .product(name: "TCSSSLPinningPublic", package: "sslpinning")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "TinkoffIDTests",
            dependencies: ["TinkoffID"],
            path: "Tests"
        ),
    ]
)
