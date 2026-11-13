// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "superwallkit_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "superwallkit-flutter", targets: ["superwallkit_flutter"])
    ],
    dependencies: [
        // Swift Package Manager builds use 4.19.1. The podspec stays on 4.18.3
        // (s.dependency 'SuperwallKit', '4.18.3') because 4.19.x isn't published
        // to CocoaPods trunk. The same sources build against both, so API that
        // only exists in 4.19.x is wrapped in `#if SWIFT_PACKAGE`, with a
        // fallback for CocoaPods.
        .package(url: "https://github.com/superwall/Superwall-iOS.git", exact: "4.19.1")
    ],
    targets: [
        .target(
            name: "superwallkit_flutter",
            dependencies: [
                .product(name: "SuperwallKit", package: "Superwall-iOS")
            ]
        )
    ]
)
