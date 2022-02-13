// swift-tools-version:5.5
<<<<<<< HEAD
=======
let package = Package(
        name: "filo",
        platforms: [
            .macOS(.v12)
        ],
        dependencies: [
            .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
            .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
            .package(url: "https://github.com/groue/GRDB.swift.git", from: "5.19.0"),
            .package(url: "https://github.com/kradalby/SwiftExif.git", from: "0.0.6"),
            .package(url: "https://github.com/cfilipov/TextTable", .branch("master")),
            .package(url: "https://github.com/malcommac/SwiftDate.git", from: "5.0.0"),
            .package(url:"https://github.com/apple/swift-argument-parser" , from: "0.0.1"),
            .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMajor(from: "0.2.3"))
        ],
        targets: [
            .executableTarget(
                    name: "filo",
                    dependencies: [
                        .product(name: "PathKit", package: "PathKit"),
                        .product(name: "GRDB", package: "GRDB.swift"),
                        .product(name: "Rainbow", package: "Rainbow"),
                        .product(name: "TextTable", package: "TextTable"),
                        .product(name: "SwiftExif", package: "SwiftExif"),
                        .product(name: "SwiftDate", package: "SwiftDate"),
                        .product(name: "ArgumentParser", package: "swift-argument-parser"),
                        .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
                    ]),
            .testTarget(
                    name: "filoTests",
                    dependencies: ["filo"]),
        ]
)
>>>>>>> feature/import-stuff
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

<<<<<<< HEAD
let package = Package(
    name: "filo",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .branch("master")),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "5.19.0"),
        .package(url: "https://github.com/kradalby/SwiftExif.git", from: "0.0.6"),
        .package(url: "https://github.com/cfilipov/TextTable", .branch("master")),
        .package(url:"https://github.com/apple/swift-argument-parser" , from: "0.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMajor(from: "0.2.3"))
    ],
    targets: [
        .executableTarget(
            name: "filo",
            dependencies: [
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "Rainbow", package: "Rainbow"),
                .product(name: "TextTable", package: "TextTable"),
                .product(name: "SwiftExif", package: "SwiftExif"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
            ]),
        .testTarget(
            name: "filoTests",
            dependencies: ["filo"]),
    ]
)
=======
>>>>>>> feature/import-stuff
