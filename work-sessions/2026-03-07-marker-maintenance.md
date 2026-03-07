# Work Session: Marker Maintenance Feature (2026-03-07)

## Status: 🔴 Research & Planning Complete (Ready for TDD)

## Objective
Implement the `MaintenanceRecord` model and logging UI using SwiftData (2026) and SwiftUI (iOS 19).

## Requirements Summary
- [x] **Model:** `MaintenanceRecord` with `markerID`, `markerName`, `date`, `shotsFired`.
- [x] **Task Logging:** Mix of pre-defined tasks (Clean, Grease, etc.) and custom notes.
- [x] **Shot Counter:** Log session-specific shots (e.g., 2000 for a case).
- [x] **Visuals:** Support for a custom marker picture (`imageData`).
- [x] **Categories:** Routine, Repair, Deep Clean.
- [x] **Platform:** iOS 19 / macOS 16 (SwiftData + CloudKit).

## Technical Plan (2026)
- **TDD Pattern:** Red -> Green -> Refactor.
- **Storage:** SwiftData `@Model` with `#Unique` on `(markerID, date)`.
- **UI:** iOS 19 "Selection-First" List for tasks, `PhotosPicker` for images, and `MeshGradient` for sleek backgrounds.

## Implementation Steps
1.  **[Current] RED:** Write failing tests for `MaintenanceRecord` (Init, Validation).
2.  **GREEN:** Implement `MaintenanceRecord.swift` with SwiftData.
3.  **REFACTOR:** Optimize for Swift 6 Concurrency.
4.  **UI:** Build `MaintenanceLoggingView` with multi-select tasks and image picker.
5.  **VERIFY:** Run all tests and manual UI review.

## Pending Clarifications
- [ ] Should we include "Quick Entry" for shot counts (e.g., 1000, 2000, 4000)?
- [ ] For multiple markers, should we have a "Marker Manager" first? (Currently assuming a free-text name or UUID is enough).
