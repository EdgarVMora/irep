# watchOS Patterns — irep

Reference for idiomatic watchOS/SwiftUI patterns used in this project. Updated as new patterns are adopted.

---

## Adaptive Layout (The Right Way)

**Never** repeat the scale factor computation. Compute once, use everywhere.

```swift
// In a View extension or private computed property:
private func scaleFactor(for size: CGSize) -> CGFloat {
    min(size.width, size.height) / 184  // 184pt = Apple Watch 40mm baseline
}
```

Or better — use `containerRelativeFrame` (iOS 17+ / watchOS 10+) which does this automatically:

```swift
Text("42")
    .containerRelativeFrame(.horizontal) { w, _ in w * 0.6 }
```

For dynamic type support, prefer `.font(.title)` system sizes over manual `CGFloat` scaling.

---

## Sensor Management Pattern

```swift
@MainActor
final class SomeMotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let processingQueue = OperationQueue()

    func startTracking() {
        guard motionManager.isSomethingAvailable else { return }
        motionManager.startUpdates(to: processingQueue) { [weak self] data, _ in
            guard let self, let data else { return }
            Task { @MainActor in self.process(data) }
        }
    }

    func stopTracking() {
        motionManager.stopUpdates()  // Always stop — don't leak sensor sessions
    }
}
```

**View wiring:**
```swift
.onAppear { manager.startTracking() }
.onDisappear { manager.stopTracking() }  // Never skip this
```

---

## Haptic Feedback

```swift
// Always on MainActor (WKInterfaceDevice is main-thread only)
WKInterfaceDevice.current().play(.success)   // Rep counted
WKInterfaceDevice.current().play(.failure)   // Error
WKInterfaceDevice.current().play(.notification) // Alert
WKInterfaceDevice.current().play(.click)     // Button tap feedback
```

---

## Transient Visual Feedback (checkmark, flash, etc.)

```swift
// In the model — don't let the view manage its own timers
private func triggerFeedback() {
    showCheckmark = true
    Task {
        try? await Task.sleep(for: .milliseconds(500))
        showCheckmark = false
    }
}
```

Animate with `.transition(.scale.combined(with: .opacity))` inside `withAnimation(.easeInOut(duration: 0.3))`.

---

## Alert Pattern

```swift
.alert("Title", isPresented: $showingAlert) {
    Button("Cancel", role: .cancel) {}
    Button("Destructive Action", role: .destructive) { viewModel.doThing() }
} message: {
    Text("Description of what will happen.")
}
```

---

## Navigation Patterns

```swift
// Root → Detail (max 2 levels)
NavigationStack {
    RootView()
        .navigationDestination(for: DetailRoute.self) { route in
            DetailView(route: route)
        }
}
```

Avoid `NavigationLink` inside `List` rows on watchOS — use `Button` + programmatic navigation for better control.

For tab-like experiences, use `TabView` with `.tabViewStyle(.page)`.

---

## Digital Crown Input

```swift
@State private var crownValue: Double = 0

SomeView()
    .focusable()
    .digitalCrownRotation(
        $crownValue,
        from: 0, through: 100, by: 1,
        sensitivity: .medium,
        isContinuous: false,
        isHapticFeedbackEnabled: true
    )
```

---

## State Management in Views

```swift
struct WorkoutView: View {
    // Owned by this view
    @StateObject private var manager = WorkoutManager()

    // Passed in from parent
    @ObservedObject var settings: AppSettings

    // Local UI state only
    @State private var showConfirmation = false

    // From environment (don't pass manually)
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
}
```

---

## HealthKit Pattern

```swift
import HealthKit

@MainActor
final class HealthManager: ObservableObject {
    private let store = HKHealthStore()

    func requestPermissions() async throws {
        let types: Set<HKSampleType> = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned)
        ]
        try await store.requestAuthorization(toShare: types, read: types)
    }
}
```

Always check `HKHealthStore.isHealthDataAvailable()` before any HealthKit call.

---

## Swift Testing (Unit Tests)

```swift
import Testing
@testable import irep_Watch_App

@Suite("MotionManager")
struct MotionManagerTests {

    @Test("counts a rep when threshold exceeded")
    func repCountIncrementsOnThreshold() async {
        let manager = MotionManager()
        // ... setup
        #expect(manager.repCount == 1)
    }

    @Test("does not double-count rapid movements")
    func noDoubleCount() async {
        // edge case
    }
}
```

---

## Localization

```swift
// In views — automatic with string literals
Text("Reset Counter")  // Automatically looked up in String Catalog

// In model code
let message = String(localized: "rep.counted.feedback")

// Plural rules
Text("^[\(count) Rep](inflect: true)")
```

---

## Watchface Complications (ClockKit → WidgetKit)

For watchOS 9+, complications use **WidgetKit**:

```swift
struct RepCounterComplication: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "repCounter", provider: RepCounterProvider()) { entry in
            RepCounterComplicationView(entry: entry)
        }
        .configurationDisplayName("Rep Counter")
        .description("Current rep count.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryRectangular])
    }
}
```
