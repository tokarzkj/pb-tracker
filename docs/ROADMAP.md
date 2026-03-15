# PB Tracker Roadmap

This roadmap outlines the feature work for the initial release, organized by domain. Each feature will follow our established TDD pattern.

## Design Directive: Specialized Focus
- **Activity vs. Analysis:** Maintain a strict separation between logging/history (Equipment focus) and performance metrics/trends (Analytics focus).
- **Tooling:** Leverage Swift Charts for trend visualization but keep specialized deep-dives out of primary management views.

## Feature 1: Marker Maintenance (Domain: Equipment) - ✅ Complete
- **Data Model:** `MaintenanceRecord` with categories, tasks, and date.
- **UI:** History list in marker detail and full-screen logging form.

## Feature 2: Field Outings (Domain: Performance) - ✅ Complete
- **Data Model:** Hierarchical `Session` (Day level) and `Outing` (Marker performance level).
- **UI:** Chronological session history and multi-marker session logging flow.

## Feature 3: Data Persistence (Domain: Core) - ✅ Complete
- **Storage:** SwiftData with CloudKit synchronization.
- **TDD:** Verified persistence and model relationships.

## Feature 4: Statistics & Insights (Domain: Analytics) - ✅ Complete
- **Calculations:** Aggregate data (Avg Eliminations, K/D Ratio, Days since maintenance).
- **TDD:** Verified aggregate math in `AnalyticsTests`.
- **UI (Dashboard):** A global `AnalyticsDashboardView` with comparative charts.
- **UI (Deep-Dive):** A dedicated `MarkerAnalyticsView` for marker-specific performance trends using Swift Charts.
