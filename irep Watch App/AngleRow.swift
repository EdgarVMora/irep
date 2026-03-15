import SwiftUI

// MARK: - AngleRow

/// Displays a single orientation angle as a labeled progress bar.
/// The bar maps the value range -180...180 degrees to a full-width fill.
struct AngleRow: View {
    let label: String
    let value: Double   // angle in degrees, expected range -180...180
    let color: Color

    // Named constant — used for both the label and value text elements.
    private let labelWidth: CGFloat = 40

    var body: some View {
        HStack(spacing: 4) {
            labelText
            barTrack
            valueText
        }
    }

    // MARK: - Private Implementation

    /// Maps a degree value in -180...180 to a bar pixel width within totalWidth.
    func barWidth(for value: Double, in totalWidth: CGFloat) -> CGFloat {
        let normalized = (value + 180) / 360   // maps -180...180 → 0...1
        let clamped = max(0, min(1, normalized))
        return CGFloat(clamped) * totalWidth
    }
}

// MARK: - Sub-views

private extension AngleRow {
    var labelText: some View {
        Text(label)
            .font(.caption)
            .foregroundStyle(color)
            .frame(width: labelWidth, alignment: .leading)
    }

    var barTrack: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 3)
                    .fill(color.opacity(0.2))
                    .frame(height: 8)

                // Foreground fill proportional to current value
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: barWidth(for: value, in: geometry.size.width), height: 8)
            }
        }
        .frame(height: 8)
    }

    var valueText: some View {
        Text("\(Int(value))°")
            .font(.caption.monospacedDigit())
            .frame(width: labelWidth, alignment: .trailing)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 8) {
        AngleRow(label: "P", value: 45, color: .blue)
        AngleRow(label: "R", value: -90, color: .green)
        AngleRow(label: "Y", value: 180, color: .orange)
    }
    .padding()
}
