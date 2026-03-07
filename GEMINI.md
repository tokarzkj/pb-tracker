# PB Tracker Project Guidelines

Follow these standards to ensure a high-quality, idiomatic Swift and SwiftUI codebase.

## Swift Best Practices

- **Early Exits:** Use `guard` statements to handle invalid states early and reduce nesting.
- **Immutability:** Always prefer `let` over `var` unless the value must change.
- **Type Safety:** Leverage Swift's strong typing; avoid `Any` or force-unwrapping (`!`) unless absolutely necessary.
- **Naming:** Follow API Design Guidelines (e.g., `camelCase` for variables/functions, `PascalCase` for types, use descriptive names).
- **Closures:** Use trailing closure syntax when a function's last argument is a closure.

## SwiftUI Best Practices

- **View Composition:** Keep views small and focused. Break complex views into smaller sub-views.
- **State Management:** 
    - Use `@State` for simple, local view state.
    - Use `@Binding` to allow child views to modify parent state.
    - Use `@StateObject` or `@Observable` (iOS 17+) for complex data models.
- **SF Symbols:** Use native SF Symbols for all icons to ensure a consistent system look.
- **Previews:** Always provide a `#Preview` for every view with representative sample data.
- **Layout:** Prefer standard containers (`VStack`, `HStack`, `ZStack`, `List`) and let SwiftUI handle adaptive spacing where possible.

## Test-Driven Development (TDD) Pattern

Follow the **Red -> Green -> Refactor** cycle for all new business logic, models, and services:

1.  **Red (Fail):** Write a failing unit test in `Tests/PBTrackerTests` that defines the expected behavior of a new feature.
2.  **Green (Pass):** Implement the minimum amount of code necessary to make the test pass.
3.  **Refactor:** Clean up the code while ensuring the tests remain green.

Do not implement new logic without first having a failing test that justifies it.

## Project Standards

- **Surgical Updates:** Avoid wholesale refactors or rewrites of existing code unless explicitly requested. Focus on targeted, minimal changes to achieve the task.
- **Testing:** Always suggest and write unit tests for any new models, services, or complex business logic. Every new model or piece of business logic must have a corresponding unit test in `Tests/PBTrackerTests`.
- **Commits:** Use clear, imperative commit messages (e.g., "Add PersonalBest model," "Refactor ContentView for better readability").
- **Documentation:** Use triple-slash (`///`) comments for public-facing properties and methods to provide Quick Help in Xcode.
