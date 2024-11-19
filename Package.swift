// swift-tools-version: 5.9
// Package.swift
import PackageDescription

let package = Package(
  name: "SwiftModernArchitecture",
  platforms: [
    .iOS(.v15),
    .macCatalyst(.v15),
    .tvOS(.v15),
    .macOS(.v13),

  ],
  products: [
    // Main library
    .library(
      name: "CoreArch", targets: ["CoreArch"]
    ),
    // Individual modules
    .library(
      name: "CoreDomain",
      targets: ["CoreDomain"]
    ),
    .library(
      name: "CorePresentation",
      targets: ["CorePresentation"]
    ),
    .library(
      name: "CoreInfrastructure",
      targets: ["CoreInfrastructure"]
    ),

  ],
  targets: [
    // MARK: Core module that ties everything together

    .target(
      name: "CoreArch",

      dependencies: [
        "CoreDomain",
        "CorePresentation",
        "CoreInfrastructure",
      ],
      path: "Sources/Core",
      packageAccess: true
    ),

    // MARK: Domain layer

    .target(
      name: "CoreDomain",
      path: "Sources/Domain"
    ),

    // MARK: Presentation layer

    .target(
      name: "CorePresentation",
      dependencies: ["CoreDomain"],
      path: "Sources/Presentation"
    ),

    // MARK: Infrastructure layer

    .target(
      name: "CoreInfrastructure",
      dependencies: ["CoreDomain"],
      path: "Sources/Infrastructure"
    ),

    // MARK: - TESTS

    .testTarget(
      name: "CoreTests",
      dependencies: [
        "CoreArch",
        "CoreDomain",
        "CoreInfrastructure",
        "CorePresentation",
      ],
      path: "Tests"
    ),
  ]
)
