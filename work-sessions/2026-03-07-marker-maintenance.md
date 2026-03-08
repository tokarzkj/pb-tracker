# Work Session: Marker Maintenance Feature (2026-03-07)

## Status: 🟢 Marker & Maintenance Core Complete

## Objective
Implement the `MaintenanceRecord` model and logging UI using SwiftData (2026) and SwiftUI (iOS 26).

## Key Achievements
- [x] **Project Foundation:** Standard iOS App project with SwiftData, CloudKit sync, and Swift Testing.
- [x] **Marker Management:** Full Add/List/Detail/Edit/Delete flow for markers.
- [x] **Maintenance Management:** Full Log/Edit/Delete flow for maintenance records.
- [x] **UI Polish:** 
    - Full-screen logging covers.
    - Required field indicators (`*`).
    - Unified image pipeline with Camera integration.

## Technical Implementation Details
### 1. Adaptive Architecture (iOS 26)
- **Unified Image Pipeline:** Created `Image+Data.swift` which abstracts `UIKit` via `#if canImport(UIKit)`. This allows the views to remain "Pure SwiftUI" while still handling raw `Data` from the camera or library.
- **SwiftData + CloudKit:** Models are designed with optional/default values and no `#Unique` constraints to ensure zero-config cross-device syncing.
- **External Storage:** Used `@Attribute(.externalStorage)` for marker photos to prevent database bloat and optimize sync performance.

### 2. Camera Integration
- **CameraManager:** Custom `AVFoundation` class handling photo capture on a background thread to avoid UI main-thread blocking.
- **Privacy:** Added `NSCameraUsageDescription` to the modern Xcode Info settings to prevent runtime crashes on physical devices.

### 3. Testing Strategy
- **Swift Testing:** Adopted the 2026 standard (`@Test` macros) using `struct`-based test suites.
- **In-Memory Store:** All tests use `isStoredInMemoryOnly: true` to ensure a clean sandbox that doesn't interfere with real user data.

## Lessons Learned
- **Bundle ID Requirement:** Discovered that Swift Package executables cannot access the Camera or SwiftData correctly because they lack a Bundle ID and proper sandboxing. Migration to a `.xcodeproj` resolved this.
- **Simulator Limitations:** Documented that the custom camera interface will crash the Simulator; physical device testing is required for the camera feature.
- **Build Destinations:** Identified that "My Mac" as a build target causes availability errors for iOS-specific features like `.glassEffect()`.

## Next Milestone (New Branch)
- **Field Outings:** Full implementation of the `Outing` UI, performance stats (Kills/Deaths), and shot logging. This will be the primary source for the `totalLifetimeShots` calculation.
