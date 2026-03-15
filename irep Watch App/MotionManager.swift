//
//  MotionManager.swift
//  irep Watch App
//
//  Created by Eddy :)  on 15/02/26.
//

import Foundation
import CoreMotion
import Combine
import WatchKit

// MARK: - MotionManager

@MainActor
final class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published var repCount: Int = 0
    @Published var showCheckmark: Bool = false

    /// Flexion/extension angle in degrees (forward/back rotation).
    @Published var pitch: Double = 0
    /// Pronation/supination angle in degrees.
    @Published var roll: Double = 0
    /// Approximate abduction angle in degrees (lateral rotation).
    @Published var yaw: Double = 0

    init() {
        queue.maxConcurrentOperationCount = 1
    }

    // MARK: - Public Interface

    func startTracking() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.05 // Update 20 times per second

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { [weak self] data, error in
            guard let self = self, let data = data else { return }

            Task { @MainActor in
                self.processAttitude(data.attitude)
            }
        }
    }

    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }

    func reset() {
        repCount = 0
        showCheckmark = false
    }

    // MARK: - Test Seam

    /// Injects attitude values expressed in radians without requiring a live `CMAttitude`.
    /// For testing only — do not call from production code.
    func updateAngles(pitchRad: Double, rollRad: Double, yawRad: Double) {
        applyAngles(pitchRad: pitchRad, rollRad: rollRad, yawRad: yawRad)
    }

    // MARK: - Private Implementation

    private func processAttitude(_ attitude: CMAttitude) {
        applyAngles(pitchRad: attitude.pitch, rollRad: attitude.roll, yawRad: attitude.yaw)
    }

    private func applyAngles(pitchRad: Double, rollRad: Double, yawRad: Double) {
        let degreesPerRadian = 180 / Double.pi
        pitch = pitchRad * degreesPerRadian
        roll  = rollRad  * degreesPerRadian
        yaw   = yawRad   * degreesPerRadian
    }
}
