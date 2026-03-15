# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**irep** is a native watchOS app built with Swift and SwiftUI, targeting watchOS 26.2+. It has an iOS container app but the primary target is the watch app.

- Bundle IDs: `com.edgarmora.irep` (iOS), `com.edgarmora.irep.watchkitapp` (watchOS)
- Swift version: 5.0
- Zero external dependencies — Apple frameworks only (SwiftUI, Foundation)

## Build & Test Commands

```bash
# Build the watch app
xcodebuild -project irep.xcodeproj -scheme "irep Watch App" -configuration Debug -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)'

# Run unit tests (Swift Testing framework)
xcodebuild test -project irep.xcodeproj -scheme "irep Watch App" -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)'
```

## Architecture

- **Entry point**: `irep Watch App/irepApp.swift` — `@main` App struct
- **Views**: `irep Watch App/ContentView.swift` — SwiftUI views
- **Tests**: `irep Watch AppTests/` (unit, Swift Testing) and `irep Watch AppUITests/` (UI, XCTest)
- **Assets**: `irep Watch App/Assets.xcassets/` — app icon, accent color

SwiftUI-first with `MainActor` default actor isolation enabled. Use SwiftUI's native state management (`@State`, `@StateObject`, `@Environment`) and structured concurrency (`async/await`).

## Conventions

- PascalCase for types, camelCase for properties/functions
- Each SwiftUI view gets a `#Preview` block
- Struct-based views (not classes)
- String catalogs enabled for localization

## PR Recommendations

- Keep PRs small and focused on a single concern to make reviews easier

---

## Agent Workflow System

This project uses a structured multi-agent workflow for feature development.

### Slash Commands
| Command | Description |
|---|---|
| `/feature` | Full feature workflow: product questions → plan → parallel implementation → review → PR |
| `/review` | Run a focused code review on all changes since main |
| `/ship` | Final review polish + create PR |

### Agent Routing (Parallelization)

```
User: Feature Requirements
         ↓
   [/feature command]
         ↓
   PHASE 1: Product Questions (orchestrator ↔ user)
         ↓
   PHASE 2: Planner Agent → task breakdown
         ↓
   PHASE 3: Parallel execution
   ┌───────────────────┬──────────────────┐
   │  Developer Agent  │   Tester Agent   │
   │  (Batch 1 tasks)  │  (unit tests)    │
   └─────────┬─────────┴──────────────────┘
             ↓ (sequential)
   Developer Agent (Batch 2 tasks)
             ↓
   PHASE 4: Build + Test verification
             ↓
   PHASE 5: Reviewer Agent (fixes issues)
             ↓
   PHASE 6: /pr → Pull Request
```

### Context & Quality Files
- `.claude/context/quality-constraints.md` — non-negotiable quality rules (living document)
- `.claude/context/watchos-patterns.md` — established SwiftUI/watchOS patterns
- `.claude/agents/` — agent definitions (planner, developer, tester, reviewer)
