//
//  irep_Watch_AppTests.swift
//  irep Watch AppTests
//
//  Created by Eddy :)  on 15/02/26.
//

import Testing
import SwiftUI
@testable import irep_Watch_App

// MARK: - MotionManager — angle conversion (TEST-1)

/// Tests for the internal `updateAngles(pitchRad:rollRad:yawRad:)` method that converts
/// radian inputs to degree values stored in `pitch`, `roll`, and `yaw` published properties.
///
/// `MotionManager` is `@MainActor`-isolated, so the whole suite must carry the same isolation.
@Suite("MotionManager — angle conversion")
@MainActor
struct MotionManagerAngleTests {

    // MARK: Zero input

    @Test("zero radians produces zero degrees on all axes")
    func zeroRadians_allAnglesZero() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: 0, yawRad: 0)
        #expect(motion.pitch == 0)
        #expect(motion.roll == 0)
        #expect(motion.yaw == 0)
    }

    // MARK: π/2 → 90°

    @Test("π/2 radians on pitch axis equals 90 degrees")
    func halfPi_equalsPitch90Degrees() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: .pi / 2, rollRad: 0, yawRad: 0)
        #expect(abs(motion.pitch - 90.0) < 0.001)
    }

    @Test("π/2 radians on roll axis equals 90 degrees")
    func halfPi_equalsRoll90Degrees() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: .pi / 2, yawRad: 0)
        #expect(abs(motion.roll - 90.0) < 0.001)
    }

    @Test("π/2 radians on yaw axis equals 90 degrees")
    func halfPi_equalsYaw90Degrees() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: 0, yawRad: .pi / 2)
        #expect(abs(motion.yaw - 90.0) < 0.001)
    }

    // MARK: π → 180°

    @Test("π radians on pitch axis equals 180 degrees")
    func pi_equalsPitch180Degrees() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: .pi, rollRad: 0, yawRad: 0)
        #expect(abs(motion.pitch - 180.0) < 0.001)
    }

    @Test("π radians on roll axis equals 180 degrees")
    func pi_equalsRoll180Degrees() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: .pi, yawRad: 0)
        #expect(abs(motion.roll - 180.0) < 0.001)
    }

    @Test("π radians on yaw axis equals 180 degrees")
    func pi_equalsYaw180Degrees() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: 0, yawRad: .pi)
        #expect(abs(motion.yaw - 180.0) < 0.001)
    }

    // MARK: -π → -180°

    @Test("negative π radians on pitch axis equals -180 degrees")
    func negativePi_equalsPitchNegative180() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: -.pi, rollRad: 0, yawRad: 0)
        #expect(abs(motion.pitch - (-180.0)) < 0.001)
    }

    @Test("negative π radians on roll axis equals -180 degrees")
    func negativePi_equalsRollNegative180() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: -.pi, yawRad: 0)
        #expect(abs(motion.roll - (-180.0)) < 0.001)
    }

    @Test("negative π radians on yaw axis equals -180 degrees")
    func negativePi_equalsYawNegative180() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: 0, rollRad: 0, yawRad: -.pi)
        #expect(abs(motion.yaw - (-180.0)) < 0.001)
    }

    // MARK: Independent axis isolation

    @Test("updateAngles does not bleed pitch value into roll or yaw")
    func pitchInput_doesNotAffectRollOrYaw() {
        let motion = MotionManager()
        motion.updateAngles(pitchRad: .pi / 2, rollRad: 0, yawRad: 0)
        #expect(abs(motion.roll) < 0.001)
        #expect(abs(motion.yaw) < 0.001)
    }
}

// MARK: - AngleRow — bar width clamping (TEST-2)

/// Tests for the internal `barWidth(for:in:)` method on `AngleRow`.
///
/// The bar represents an angle in [-180, 180]. A value of 0 maps to the midpoint (50% of
/// totalWidth). Values outside the range are clamped to [0, totalWidth].
///
/// `AngleRow` is a SwiftUI `View` struct with no actor isolation, so no `@MainActor` annotation
/// is needed here.
@Suite("AngleRow — bar width")
struct AngleRowBarWidthTests {

    // MARK: Midpoint

    @Test("angle of 0 maps to half of total width")
    func zeroAngle_halfWidth() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: 0, in: 100)
        #expect(width == 50.0)
    }

    // MARK: Positive boundary

    @Test("angle of 180 maps to full total width")
    func positiveMax_fullWidth() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: 180, in: 100)
        #expect(width == 100.0)
    }

    // MARK: Negative boundary

    @Test("angle of -180 maps to zero width")
    func negativeMax_zeroWidth() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: -180, in: 100)
        #expect(width == 0.0)
    }

    // MARK: Clamping above range

    @Test("angle above 180 clamps to full total width")
    func overRange_clampsToFull() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: 270, in: 100)
        #expect(width == 100.0)
    }

    // MARK: Clamping below range

    @Test("angle below -180 clamps to zero width")
    func underRange_clampsToZero() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: -270, in: 100)
        #expect(width == 0.0)
    }

    // MARK: Proportional midpoints

    @Test("angle of 90 maps to three-quarters of total width")
    func positiveHalf_threeQuarterWidth() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: 90, in: 100)
        #expect(abs(width - 75.0) < 0.001)
    }

    @Test("angle of -90 maps to one-quarter of total width")
    func negativeHalf_quarterWidth() {
        let row = AngleRow(label: "Pitch", value: 0, color: .blue)
        let width = row.barWidth(for: -90, in: 100)
        #expect(abs(width - 25.0) < 0.001)
    }

    // MARK: Different totalWidth values

    @Test("bar width scales proportionally with a larger totalWidth")
    func zeroAngle_halfWidthForDifferentTotalWidth() {
        let row = AngleRow(label: "Roll", value: 0, color: .green)
        let width = row.barWidth(for: 0, in: 200)
        #expect(width == 100.0)
    }
}
