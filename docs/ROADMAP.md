# PB Tracker Roadmap

This roadmap outlines the feature work for the initial release, organized by domain. Each feature will follow our established TDD pattern.

## Feature 1: Marker Maintenance (Domain: Equipment)
- **Data Model:** Create `MaintenanceRecord` with fields for tasks (cleaning, greasing, parts replacement), shot count, and date.
- **TDD:** Test serialization/deserialization and validation logic.
- **UI:** A list view for maintenance history and a form to log new maintenance sessions.

## Feature 2: Field Outings (Domain: Performance)
- **Data Model:** Create `OutingRecord` with fields for field location, paint brand/grade, eliminations, deaths, and total shots.
- **TDD:** Test calculations (e.g., elimination/death ratio) and persistence.
- **UI:** A list view of past outings and a multi-step form to record a new session.

## Feature 3: Data Persistence (Domain: Core)
- **Storage:** Implement SwiftData or File-based storage for all records.
- **TDD:** Verify that data persists across app launches.

## Feature 4: Statistics & Insights (Domain: Analytics)
- **Calculations:** Aggregate data (e.g., total shots fired, average eliminations per outing, days since last maintenance).
- **TDD:** Verify correctness of all aggregate math.
- **UI:** A dashboard view showing high-level stats.
