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
        VStack(spacing: 20) {
            // Checkmark emoji that appears on movement
            if motionManager.showCheckmark {
                Text("✅")
                    .font(.system(size: 80))
                    .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
            
            // Rep counter
            VStack(spacing: 8) {
                Text("Reps")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("\(motionManager.repCount)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
            }
            
            Spacer()
            
            // Reset button
            Button(action: {
                motionManager.reset()
            }) {
                Label("Reset", systemImage: "arrow.counterclockwise")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .disabled(motionManager.repCount == 0)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 0.15, green: 0.2, blue: 0.35), Color(red: 0.08, green: 0.12, blue: 0.22)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            motionManager.startTracking()
        }
        .onDisappear {
            motionManager.stopTracking()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: motionManager.showCheckmark)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: motionManager.repCount)
    }
}

#Preview {
    ContentView()
}

