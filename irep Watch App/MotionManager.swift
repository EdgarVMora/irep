//
//  MotionManager.swift
//  irep Watch App
//
//  Created by Eddy :)  on 15/02/26.
//

import Foundation
import CoreMotion
import SwiftUI
import Combine
import WatchKit

@MainActor
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    @Published var repCount: Int = 0
    @Published var showCheckmark: Bool = false
    
    private var lastAccelerationY: Double = 0
    private var isMovingUp: Bool = false
    private let threshold: Double = 0.3 // Sensitivity threshold for wrist raise detection
    
    init() {
        queue.maxConcurrentOperationCount = 1
    }
    
    func startTracking() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available")
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1 // Update 10 times per second
        
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            
            Task { @MainActor in
                self.processMotionData(data)
            }
        }
    }
    
    func stopTracking() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func processMotionData(_ data: CMAccelerometerData) {
        let currentY = data.acceleration.y
        let delta = currentY - lastAccelerationY
        
        // Detect upward movement (wrist raise)
        if delta > threshold && !isMovingUp {
            isMovingUp = true
            detectRep()
        } else if delta < -threshold {
            isMovingUp = false
        }
        
        lastAccelerationY = currentY
    }
    
    private func detectRep() {
        repCount += 1
        showCheckmark = true
        
        // Provide haptic feedback
        WKInterfaceDevice.current().play(.success)
        
        // Hide checkmark after 0.5 seconds
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            showCheckmark = false
        }
    }
    
    func reset() {
        repCount = 0
        showCheckmark = false
    }
}
