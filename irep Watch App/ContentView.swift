//
//  ContentView.swift
//  irep Watch App
//
//  Created by Eddy :)  on 15/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()

    var body: some View {
        VStack(spacing: 6) {
            Text("Arm Orientation")
                .font(.caption2)
                .foregroundStyle(.secondary)
            AngleRow(label: "Pitch", value: motionManager.pitch, color: .blue)
            AngleRow(label: "Roll", value: motionManager.roll, color: .green)
            AngleRow(label: "Yaw", value: motionManager.yaw, color: .orange)
        }
        .padding(.horizontal, 8)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.2, blue: 0.35),
                    Color(red: 0.08, green: 0.12, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .onAppear { motionManager.startTracking() }
        .onDisappear { motionManager.stopTracking() }
    }
}

// MARK: - Preview

#Preview("Apple Watch 40mm") {
    ContentView()
}

#Preview("Apple Watch 44mm") {
    ContentView()
        .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
}
#Preview("Apple Watch 49mm") {
    ContentView()
        .previewDevice(PreviewDevice(rawValue: "Apple Watch Ultra (49mm)"))
}

