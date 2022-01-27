// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "filo",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/hlemai/ExifTool.git", from: "2.2.3"),
        .package(url:"https://github.com/apple/swift-argument-parser" , from: "0.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "filo",
            dependencies: [
                .product(name: "Rainbow", package: "Rainbow"),
                .product(name: "ExifTool", package: "ExifTool"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
                
            ]),
        .testTarget(
            name: "filoTests",
            dependencies: ["filo"]),
    ]
)
