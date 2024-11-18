# Getting Started

Learn how to integrate SwiftModernArchitecture into your iOS app.

## Overview

SwiftModernArchitecture helps you build scalable iOS apps using Clean Architecture principles. This guide walks you through basic setup and usage.

## Adding the Package

Add the package to your Xcode project:

```swift
dependencies: [
.package(url: "https://github.com/NSFuntik/SwiftModernArchitecture", from: "1.0.0")
]
```

## Basic Usage

### Define Your Model

```swift
struct User: Entity {
  let id: UUID
  let name: String
}
```

### Create a Feature

```swift
final class UsersFeature: Feature {
  typealias Input = UserRequest
  typealias Output = [User]
  func execute(input: Input) async throws -> Output {
    // Implementation
  }
}
```

### Create a View

```swift
struct UsersView: View {
  var body: some View {
    LoadableView(source: usersFeature, input: .all) { users in
      List(users) { user in
        Text(user.name)
      }
    }
  }
}
```

## Topics

### Essentials

- <doc:Architecture>
- <doc:Installation>

### Next Steps

- <doc:CoreConcepts>
- <doc:DependencyInjection>
