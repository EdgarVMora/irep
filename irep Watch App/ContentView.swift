//
//  ContentView.swift
//  irep Watch App
//
//  Created by Eddy :)  on 15/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello from Noe 💪")
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
    }
}

#Preview {
    ContentView()
}
