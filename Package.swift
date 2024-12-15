// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncSwiftData",
    platforms: [.iOS(.v17)],
    dependencies: []
)

package.products = [
    .library(
        name: "AsyncSwiftData",
        targets: [.targetName]
    )
]

package.targets = [
    .target(name: .targetName),
    .testTarget(
        name: .testTargetName,
        dependencies: [
            .target(name: .targetName)
        ]
    )
]

private extension String {
    static let targetName = "AsyncSwiftData"

    // MARK: ForTests
    static let testTargetName = "AsyncSwiftDataTests"
}
