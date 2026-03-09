//
//  ContentView.swift
//  irep Watch App
//
//  Created by Eddy :)  on 15/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @State private var showingResetAlert = false
    @State private var isTracking = false
    
    // Detectar el tamaño de la pantalla para hacer el diseño responsive
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: adaptiveSpacing(for: geometry.size)) {
                // Checkmark de feedback visual
                if motionManager.showCheckmark {
                    CheckmarkView()
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Contador principal - Tamaño adaptativo
                VStack(spacing: 4) {
                    Text("REPETICIONES")
                        .font(.system(size: adaptiveCaptionSize(for: geometry.size), weight: .medium))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text("\(motionManager.repCount)")
                        .font(.system(size: adaptiveCounterSize(for: geometry.size), weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Botones de control - Tamaño adaptativo
                HStack(spacing: adaptiveButtonSpacing(for: geometry.size)) {
                    // Botón Start/Stop
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if isTracking {
                                motionManager.stopTracking()
                                isTracking = false
                            } else {
                                motionManager.startTracking()
                                isTracking = true
                            }
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(isTracking ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                                .frame(width: adaptiveButtonSize(for: geometry.size), 
                                       height: adaptiveButtonSize(for: geometry.size))
                            
                            Image(systemName: isTracking ? "stop.fill" : "play.fill")
                                .font(.system(size: adaptiveIconSize(for: geometry.size), weight: .semibold))
                                .foregroundStyle(isTracking ? .red : .green)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    // Botón Reset
                    Button {
                        showingResetAlert = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: adaptiveButtonSize(for: geometry.size), 
                                       height: adaptiveButtonSize(for: geometry.size))
                            
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: adaptiveIconSize(for: geometry.size) * 0.85, weight: .semibold))
                                .foregroundStyle(.orange)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(motionManager.repCount == 0)
                    .opacity(motionManager.repCount == 0 ? 0.4 : 1.0)
                }
                .padding(.bottom, adaptiveBottomPadding(for: geometry.size))
            }
            .padding(.horizontal, adaptiveHorizontalPadding(for: geometry.size))
            .padding(.vertical, adaptiveVerticalPadding(for: geometry.size))
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
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
        .alert("Resetear Contador", isPresented: $showingResetAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Resetear", role: .destructive) {
                withAnimation {
                    motionManager.reset()
                }
            }
        } message: {
            Text("¿Quieres resetear el contador a 0?")
        }
    }
    
    // MARK: - Adaptive Sizing Functions
    
    /// Tamaño del contador basado en el tamaño de pantalla
    private func adaptiveCounterSize(for size: CGSize) -> CGFloat {
        let baseSize: CGFloat = 70
        let scaleFactor = min(size.width, size.height) / 184 // 184 es el ancho del Apple Watch 40mm
        return baseSize * scaleFactor
    }
    
    /// Tamaño del caption basado en el tamaño de pantalla
    private func adaptiveCaptionSize(for size: CGSize) -> CGFloat {
        let baseSize: CGFloat = 11
        let scaleFactor = min(size.width, size.height) / 184
        return baseSize * scaleFactor
    }
    
    /// Tamaño de los botones basado en el tamaño de pantalla
    private func adaptiveButtonSize(for size: CGSize) -> CGFloat {
        let baseSize: CGFloat = 50
        let scaleFactor = min(size.width, size.height) / 184
        return baseSize * scaleFactor
    }
    
    /// Tamaño de los iconos basado en el tamaño de pantalla
    private func adaptiveIconSize(for size: CGSize) -> CGFloat {
        let baseSize: CGFloat = 20
        let scaleFactor = min(size.width, size.height) / 184
        return baseSize * scaleFactor
    }
    
    /// Espaciado entre elementos basado en el tamaño de pantalla
    private func adaptiveSpacing(for size: CGSize) -> CGFloat {
        let baseSpacing: CGFloat = 12
        let scaleFactor = min(size.width, size.height) / 184
        return baseSpacing * scaleFactor
    }
    
    /// Espaciado entre botones basado en el tamaño de pantalla
    private func adaptiveButtonSpacing(for size: CGSize) -> CGFloat {
        let baseSpacing: CGFloat = 16
        let scaleFactor = min(size.width, size.height) / 184
        return baseSpacing * scaleFactor
    }
    
    /// Padding horizontal basado en el tamaño de pantalla
    private func adaptiveHorizontalPadding(for size: CGSize) -> CGFloat {
        let basePadding: CGFloat = 12
        let scaleFactor = min(size.width, size.height) / 184
        return basePadding * scaleFactor
    }
    
    /// Padding vertical basado en el tamaño de pantalla
    private func adaptiveVerticalPadding(for size: CGSize) -> CGFloat {
        let basePadding: CGFloat = 8
        let scaleFactor = min(size.width, size.height) / 184
        return basePadding * scaleFactor
    }
    
    /// Padding inferior basado en el tamaño de pantalla
    private func adaptiveBottomPadding(for size: CGSize) -> CGFloat {
        let basePadding: CGFloat = 8
        let scaleFactor = min(size.width, size.height) / 184
        return basePadding * scaleFactor
    }
}

// MARK: - Checkmark View

/// Vista de checkmark animado que aparece cuando se detecta una repetición
struct CheckmarkView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.green.opacity(0.3))
                .frame(width: 60, height: 60)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.green)
        }
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

