# PB Tracker - Technical Requirements (2026)

## 1. Platform & Language
- **Language:** Swift 6.0+ (Strict Concurrency enabled)
- **Minimum OS:** iOS 19.0 / macOS 16.0
- **Framework:** SwiftUI (Modern Lifecycle)

## 2. Data Persistence (User-Owned)
- **Engine:** SwiftData
- **Sync:** CloudKit (Private Database)
- **Privacy:** No external servers. All data is encrypted and stored in the user's Apple ID container.
- **Features:** 
    - Use `#Unique` for record integrity.
    - Use `#Index` for high-performance history searching.

## 3. UI/UX Standards
- **Design System:** "Liquid Glass" aesthetic.
- **Components:**
    - **Charts:** Native SwiftUI Charts for performance analytics.
    - **Transitions:** Native `.matchedTransitionSource` for hero-style animations.
    - **Visuals:** `MeshGradient` for premium backgrounds.
    - **Feedback:** Haptic feedback on all logging actions.

## 4. Intelligence & Integration
- **App Intents:** Full support for Siri and Shortcuts to enable voice logging.
- **Widgets:** Interactive Home Screen and Lock Screen widgets for "Last Maintenance" status.
