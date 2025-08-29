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
    @StateObject private var stationLineStore = StationLineStore()
    var body: some Scene {
        WindowGroup{
            HomeView()
                .environmentObject(stationLineStore)
        }
        /*WindowGroup {
            TubeRouteView()
                .environmentObject(stationStore)
        }*/
    }
}

// MARK: - Store
class StationStore: ObservableObject {
    @Published var stations: [Station]
    
    init() {
        self.stations = loadStations().sorted { $0.name < $1.name }
    }
}

private let visitedStationsKey = "visitedStations"
private let visitedLinesKey = "visitedLines"
private let initializedKey = "progressInitialized"

class StationLineStore: ObservableObject {
    @Published var stations: [String]
    @Published var lines: [String]
    
    init() {
        let tubeData = loadTubeData()
        self.stations = tubeData.stations
        self.lines = tubeData.lines
        
        initializeDefaultsIfNeeded()
    }
    
    private func initializeDefaultsIfNeeded() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: initializedKey) {
            let stationDict = Dictionary(uniqueKeysWithValues: stations.map { ($0, false) })
            let lineDict = Dictionary(uniqueKeysWithValues: lines.map { ($0, false) })
            
            defaults.set(stationDict, forKey: visitedStationsKey)
            defaults.set(lineDict, forKey: visitedLinesKey)
            
            defaults.set(true, forKey: initializedKey)
        }
    }
}
