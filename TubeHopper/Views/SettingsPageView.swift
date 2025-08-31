//
//  SettingsPageView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 29/08/2025.
//


import SwiftUI

struct SettingsPageView: View {
    @EnvironmentObject var store: StationStore
    @State private var showResetAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                showResetAlert = true
            }) {
                Text("Reset Progress")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding()
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Reset Progress?"),
                    message: Text("Are you sure you want to reset all visited and passed-through stations?"),
                    primaryButton: .destructive(Text("Yes")) {
                        resetProgress()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .navigationTitle("Settings")
    }
    
    private func resetProgress() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "visitedStations")
        defaults.removeObject(forKey: "passedThroughStations")
        defaults.removeObject(forKey: "visitedLines")
        defaults.set(false, forKey: "progressInitialized")
        
        store.initializeDefaultsIfNeeded()
        store.objectWillChange.send()
    }
}
