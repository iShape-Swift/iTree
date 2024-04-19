// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iTree",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iTree",
            targets: ["iTree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/iShape-Swift/iFixFloat", .upToNextMajor(from: "1.7.0")),
//        .package(path: "../iFixFloat"),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iTree"),
        .testTarget(
            name: "iTreeTests",
            dependencies: ["iTree", "iFixFloat"]),
    ]
)
