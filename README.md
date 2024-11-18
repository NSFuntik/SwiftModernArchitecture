# SwiftUI Modern Clean Architecture
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![Swift Version](https://img.shields.io/badge/swift-5.5-orange.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%2015%2B%20%7C%20macOS%2012%2B%20%7C%20tvOS%2015%2B%20%7C%20macCatalyst%2015%2B-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A lightweight, scalable and modern iOS architecture template based on Clean Architecture principles and SwiftUI.

## Overview

This template provides a clean and maintainable architecture for iOS apps with clear separation of concerns, dependency injection, and SwiftUI integration.

## Features

- 🏗 Clean Architecture implementation
- 📦 Modular design
- 🔄 Async/await support
- 💉 Simple dependency injection 
- 🧪 Testable by design
- 📱 SwiftUI first
- 🎯 iOS 15+ & macOS 13+
- 🧩 Easy to extend

## Project Structure

```
ModernCleanSwiftUI/
├── Sources/
│   ├── Domain/
│   │   ├── Entity.swift
│   │   ├── Repository.swift
│   │   └── ViewState.swift
│   ├── Infrastructure/
│   │   ├── Network/
│   │   └── Storage/
│   └── Presentation/
│       └── Views/
└── Tests/
```

## Installation

1. Add the package to your Xcode project:
```swift
dependencies: [
    .package(url: "https://github.com/NSFuntik/SwiftModernArchitecture", from: "1.0.0")
]
```

2. Import the modules you need:
```swift
import Domain
import Presentation
import Infrastructure
```

## Basic Usage

### 1. Define Your Model

```swift
struct User: Entity {
    let id: UUID
    let name: String
}
```

### 2. Create a Feature

```swift
final class UsersFeature: Feature {
    typealias Input = UserRequest
    typealias Output = [User]
    
    func execute(_ input: Input) async throws -> Output {
        // Implementation
    }
}
```

### 3. Create a View

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

## Key Components

### Domain Layer

- `Entity`: Base protocol for domain models
- `Repository`: Data access abstraction
- `Feature`: Combined repository and business logic

### Infrastructure Layer

- `APIClient`: Network communication
- `StorageService`: Data persistence

### Presentation Layer

- `LoadableView`: Data loading container
- `ResourceView`: State handling
- `PaginatedView`: Pagination support

## Best Practices

1. Keep layers separate and dependencies clean:
   - Domain has no dependencies
   - Infrastructure depends on Domain
   - Presentation depends on Domain

2. Use dependency injection:
```swift
@Inject private var feature: UsersFeature
```

3. Handle states properly:
```swift
LoadableView(source: feature, input: input) { data in
    // Success state
}
```

4. Write tests for each layer:
```swift
class FeatureTests: XCTestCase {
    func testFeature() async throws {
        // Test implementation
    }
}
```

## Benefits

- ✅ Clear separation of concerns
- ✅ Highly testable architecture
- ✅ Modern Swift features
- ✅ SwiftUI integration
- ✅ Minimal dependencies
- ✅ Easy to understand and extend
- ✅ Production ready

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests.

## Requirements

- iOS 15.0+
- macOS 13.0+
- Xcode 14.0+
- Swift 5.9+

## License

This project is available under the MIT license.
