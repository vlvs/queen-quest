# 𖣯 Queen Quest ✧

Queen Quest is a small SwiftUI game based on the classic [N-Queens problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle). The goal is to place _n_ queens on an _n_ × _n_ chessboard such that no queen threatens another (no same row, column, or diagonal).

The game provides real-time validation for queen placements and highlights conflicts, tracks the time taken to solve each iteration of the puzzle, saves best times per board size, and celebrates wins with haptics + animations + SFX.  

## Requirements

- Xcode 26
- iOS 26.2 (Device or Simulator)

## Running

### Xcode
1. Open `QueenQuest.xcodeproj`
2. Select the `QueenQuest` scheme
3. Choose a device/simulator
4. Press `Run (⌘R)`

## Testing

Run tests from Xcode with the `Test (⌘U)` command.
- The `Test navigator (⌘6)` will display a list of all executed tests and their boolean results.
- The `Report navigator (⌘9)` provides further details like timings, logs and coverage reports.

The project is unit-test heavy for fast feedback and strong logic coverage (game rules, timing, persistence). UI tests are intentionally light and focus on validating the core end-to-end flow.

## Architectural Decisions

### MVVM Core

The UI is built with SwiftUI views responsible for rendering state and forwarding user intent so that there's clear separation between presentation and logic.
- `QueenQuestView` owns presentation concerns (layout, overlays, simple view-only timing for effects).
- `QueenQuestViewModel` owns the game state machine: board size, queen placement, queen conflicts, solved state, timing, best time updates.

### Unidirectional Data Flow & Derived State

State flows one way:
- User taps → `toggleQueen(at:)` in the view model.
- View model mutates canonical state (`queens`, `boardSize`, `startTime`)
- View model recomputes derived state (`conflicts`, `isSolved`, `elapsedTime`)

The `conflicts` set and the `isSolved` flag are derived from `queens`. This keeps the UI declarative and makes state transitions predictable and testable.

### Injected Dependencies for Reliable Tests

- Persistence is abstracted behind the `BestTimesStore` interface while the concrete implementation resides in `BestTimesStoreImpl`, backed by `UserDefaults` (appropriate for a small, non-sensitive, device-local state).
- Time is abstracted via `Clock` / `SystemClock` so that the view model never calls `Date()` directly, enabling unit tests to assert elapsed time and best time behavior without sleeps or flaky timing.

The protocol boundaries keep the view model decoupled from storage details and enable deterministic unit tests.

### Componentized UI

The UI is composed from focused components (e.g., `BoardView`, `BoardControlsView`, `GameStatusBarView`). Each component has a clear responsibility and minimal inputs (data in, callbacks out). This reduces compile-time complexity, improves readability and facilitates extension.

### Consciously Managed Complexity

The conflict detection algorithm is a straightforward O(n²) pairwise check, justified by small board sizes (4-10) and clarity. The algorithm is easy to reason about and easy to test. Optimization is deferred until a real need emerges.

### Result

A small, maintainable codebase with clear separation of concerns, deterministic core logic, high unit test coverage, and minimal—but meaningful—UI coverage.
