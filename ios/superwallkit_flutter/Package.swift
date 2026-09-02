// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "superwallkit_flutter",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "superwallkit-flutter", targets: ["superwallkit_flutter"])
    ],
    dependencies: [
        // Pinned to match the version declared in the podspec
        // (s.dependency 'SuperwallKit', '4.14.2').
        .package(url: "https://github.com/superwall/Superwall-iOS.git", exact: "4.14.2")
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
