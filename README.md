# irep

![Platform](https://img.shields.io/badge/platform-watchOS%2026.2+-black?logo=apple)
![Swift](https://img.shields.io/badge/swift-5.0-orange?logo=swift)
![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

A native Apple Watch app that counts workout repetitions using the wrist accelerometer — no phone needed, no tapping required.

---

## What it does

irep detects repetitive wrist movements (curls, rows, presses) and counts each rep automatically. Tap once to start, once to stop. That's it.

- Automatic rep detection via accelerometer
- Haptic feedback on every counted rep
- Adaptive layout across all Apple Watch sizes (40mm → 49mm Ultra)
- Works entirely on-watch, no iPhone dependency

---

## Requirements

| | |
|---|---|
| **watchOS** | 26.2+ |
| **Xcode** | 16+ |
| **Device** | Apple Watch Series 4 or later (for accelerometer) |

---

## Getting Started

```bash
git clone https://github.com/yourusername/irep.git
cd irep
open irep.xcodeproj
```

Select the **irep Watch App** scheme, choose a watchOS simulator or your paired Apple Watch, and run.

### Build from terminal

```bash
xcodebuild \
  -project irep.xcodeproj \
  -scheme "irep Watch App" \
  -configuration Debug \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)'
```

### Run tests

```bash
xcodebuild test \
  -project irep.xcodeproj \
  -scheme "irep Watch App" \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)'
```

---

## Project Structure

```
irep Watch App/
├── irepApp.swift          # App entry point
├── ContentView.swift      # Main screen — counter, start/stop, reset
├── MotionManager.swift    # Accelerometer wrapper, rep detection logic
└── Assets.xcassets/       # App icon, accent color

irep Watch AppTests/       # Unit tests (Swift Testing)
irep Watch AppUITests/     # UI tests (XCTest)
```

---

## Contributing with Claude Code

This project uses **Claude Code** with a structured multi-agent workflow. Features go from idea to PR with minimal friction.

### Setup

Install [Claude Code](https://claude.ai/code), then open the project:

```bash
claude
```

### Starting a new feature

Type the slash command:

```
/feature
```

Claude will ask you a series of product and UX questions (scope, interaction model, watchOS constraints), then autonomously:

1. Plan the implementation with a parallelizable task breakdown
2. Implement with a specialized watchOS/SwiftUI agent
3. Write tests in parallel with a dedicated tester agent
4. Run the build and test suite
5. Review the code for quality, bugs, and cognitive load
6. Open a pull request

You stay at the product level. Claude handles the rest.

### Other commands

| Command | Description |
|---|---|
| `/feature` | Start the full feature workflow |
| `/review` | Code review all changes since `main` |
| `/ship` | Final review polish + create PR |

### Quality bar

The project maintains strict quality constraints documented in `.claude/context/quality-constraints.md`. Every agent reads these before writing or reviewing code. Key rules:

- No duplicate logic — extract it
- View bodies ≤ 40 lines — extract sub-views
- No magic numbers — name your constants
- Sensors always stopped on `onDisappear`
- All user-visible strings localized via String Catalogs
- Every new view gets a `#Preview` block

---

## License

MIT
