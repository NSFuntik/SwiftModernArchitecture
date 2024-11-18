# Architecture

Learn about the Clean Architecture implementation in SwiftModernArchitecture.

## Overview

SwiftModernArchitecture follows Clean Architecture principles with three main layers:

- Domain Layer: Business logic and models
- Infrastructure Layer: External interfaces
- Presentation Layer: UI and user interaction

## Layer Dependencies

The dependencies flow from outer to inner layers: 

``` 
Presentation -> Domain -> Infrastructure
```

## Key Components

### Domain Layer

The Domain layer contains:

- Entities: Core business models
- Repositories: Data access interfaces
- Features: Business logic components
- Use Cases: Application specific logic

### Infrastructure Layer

The Infrastructure layer provides:

- Network communication
- Data persistence
- External service integration

### Presentation Layer

The Presentation layer includes:

- SwiftUI views
- View models
- UI state management
- User interaction handling

## Topics

### Domain Layer

- ``Entity``
- ``Repository``
- ``Feature``

### Infrastructure Layer

- ``APIClient``
- ``StorageService``

### Presentation Layer

- ``LoadableView``
- ``ResourceView``