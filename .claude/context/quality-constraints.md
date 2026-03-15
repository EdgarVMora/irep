# Quality Constraints — irep watchOS

Living document. Updated as new patterns or anti-patterns are discovered. All agents MUST read this before writing or reviewing code.

---

## Non-Negotiable Rules

### 1. No Duplicate Logic
Every piece of logic lives in exactly one place. If two things look similar, extract them.

**Anti-pattern caught in production:**
```swift
// BAD: 9 functions all doing `baseValue * min(w,h) / 184`
private func adaptiveCounterSize(for size: CGSize) -> CGFloat { 70 * min(size.width, size.height) / 184 }
private func adaptiveCaptionSize(for size: CGSize) -> CGFloat { 11 * min(size.width, size.height) / 184 }
// ... 7 more identical functions

// GOOD: one scale factor, use it everywhere
private func scaleFactor(for size: CGSize) -> CGFloat { min(size.width, size.height) / 184 }
// Then: 70 * scaleFactor(for: size), 11 * scaleFactor(for: size)
```

### 2. Cognitive Load Budget
A reader should understand any function in under 10 seconds. If it takes longer, refactor.
- Max ~3 levels of nesting per view body
- Extract sub-views when a `body` exceeds ~40 lines
- No anonymous magic numbers — use named constants or computed properties

### 3. SwiftUI State Correctness
- `@State` for local, ephemeral, view-owned state only
- `@StateObject` for the owning view; `@ObservedObject` for views that receive it
- Never derive state from other state imperatively — use computed properties or `.onChange`
- Side effects belong in `.task {}`, `.onAppear {}`, or in the model, not in `body`

### 4. watchOS Performance
- No blocking the main thread. All sensor/IO work goes through a background `OperationQueue` then dispatches back via `Task { @MainActor in ... }`
- Haptic feedback calls (`WKInterfaceDevice.current().play(...)`) must be on MainActor
- Keep `accelerometerUpdateInterval` ≥ 0.05s (20Hz max for rep counting — finer granularity wastes battery)
- Avoid `GeometryReader` wrapping entire screens when `containerRelativeFrame` or fixed sizes suffice

### 5. No Defensive Code for Internal Invariants
If a value is guaranteed by the app's own logic, don't guard against it. Only validate at system boundaries (CMMotionManager output, user input, external APIs).

### 6. String Catalogs — No Hardcoded Strings
User-visible strings go through `LocalizedStringKey` / `String(localized:)`. The project has string catalogs enabled.
Exception: developer-facing `print()`/`Logger` messages — those stay in English literals.

### 7. Accessibility
Every interactive element needs `.accessibilityLabel` and `.accessibilityHint` when the default description is ambiguous. On watchOS, VoiceOver users navigate with a single finger — ensure tap targets are ≥ 44×44pt.

### 8. Previews
Every new `View` gets a `#Preview` block. Multi-watch-size previews for layout-sensitive views (use 40mm as baseline, add 49mm for Ultra stress test).

### 9. Structured Concurrency — No Naked Callbacks
New code uses `async/await`. `CMMotionManager` callback → bridge with `AsyncStream` or dispatch to `Task { @MainActor in }`. Never nest completion handlers.

### 10. File Organization
```
// Each file:
// MARK: - Public Interface     (init, public funcs)
// MARK: - Private Implementation
// MARK: - Preview (views only)
```
One primary type per file. File name = primary type name.

---

## watchOS-Specific Constraints

| Concern | Rule |
|---|---|
| Screen time | Interactions must complete in ≤ 2 taps. Users glance for ~2–5s |
| Navigation depth | Max 2 levels deep (root + one detail). No deep stacks |
| Digital Crown | Use `.focusable()` + `.digitalCrownRotation` for scroll/numeric input instead of pickers when possible |
| Complications | If a feature has a persistent metric, add a complication entry point |
| Background | `WKExtendedRuntimeSession` only when genuinely needed; document why |
| Battery | Stop all sensor updates when view disappears (`onDisappear`) |
| Memory | < 50MB memory budget for watchOS. No large in-memory arrays |

---

## Code Review Checklist (for reviewer agent)

- [ ] No logic duplicated across functions or files
- [ ] No magic numbers (unless self-evident: 0, 1, 100%)
- [ ] View body ≤ 40 lines or extracted into sub-views
- [ ] All user-visible strings localized
- [ ] Sensors/motion stopped in `onDisappear` or `stopTracking`
- [ ] `@StateObject` vs `@ObservedObject` used correctly
- [ ] No `DispatchQueue.main.async` — use `Task { @MainActor in }`
- [ ] Every new View has `#Preview`
- [ ] Accessibility labels on ambiguous controls
- [ ] No unused imports or variables
- [ ] Tests cover the happy path and at least one failure/edge case
