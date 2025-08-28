//
//  TubeHopperApp.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import SwiftUI

@main
struct TubeHopperApp: App {
    @StateObject private var stationStore = StationStore()
    var body: some Scene {
        WindowGroup {
            TubeRouteView()
                .environmentObject(stationStore)
        }
    }
}

// MARK: - Store
class StationStore: ObservableObject {
    @Published var stations: [Station]
    
    init() {
        self.stations = loadStations().sorted { $0.name < $1.name }
    }
}
