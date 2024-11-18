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
      name: "CoreArch", targets: ["Core"]
    ),
    // Individual modules
    .library(
      name: "CoreDomain",
      targets: ["Domain"]
    ),
    .library(
      name: "CorePresentation",
      targets: ["Presentation"]
    ),
    .library(
      name: "CoreInfrastructure",
      targets: ["Infrastructure"]
    ),

  ],
  targets: [
    // MARK: Core module that ties everything together

    .target(
      name: "Core",

      dependencies: [
        "Domain",
        "Presentation",
        "Infrastructure",
      ],
      path: "Sources/Core",
      packageAccess: true
    ),

    // MARK: Domain layer

    .target(
      name: "Domain",
      path: "Sources/Domain"
    ),

    // MARK: Presentation layer

    .target(
      name: "Presentation",
      dependencies: ["Domain"],
      path: "Sources/Presentation"
    ),

    // MARK: Infrastructure layer

    .target(
      name: "Infrastructure",
      dependencies: ["Domain"],
      path: "Sources/Infrastructure"
    ),

    // MARK: - TESTS

    .testTarget(
      name: "Tests",
      dependencies: [
        "Core",
        "Domain",
        "Infrastructure",
        "Presentation",
      ],
      path: "Tests"
    ),
  ]
)
