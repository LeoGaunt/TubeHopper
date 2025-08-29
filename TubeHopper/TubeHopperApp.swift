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
        WindowGroup{
            HomeView()
                .environmentObject(stationStore)
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
    
    private let visitedStationsKey = "visitedStations"
    private let visitedLinesKey = "visitedLines"
    private let initializedKey = "progressInitialized"
    
    init() {
        self.stations = loadStations().sorted { $0.name < $1.name }
        initializeDefaultsIfNeeded()
    }
    
    // MARK: - UserDefaults initialization
    private func initializeDefaultsIfNeeded() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: initializedKey) {
            // Mark all stations as not visited
            let stationDict = Dictionary(uniqueKeysWithValues: stations.map { ($0.name, false) })
            defaults.set(stationDict, forKey: visitedStationsKey)
            
            // Mark all lines as not visited
            let allLines = Set(stations.flatMap { $0.lines })
            let lineDict = Dictionary(uniqueKeysWithValues: allLines.map { ($0, false) })
            defaults.set(lineDict, forKey: visitedLinesKey)
            
            defaults.set(true, forKey: initializedKey)
        }
    }
    
    // MARK: - Update station visited
    func markStationVisited(_ stationName: String) {
        var visitedStations = UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
        visitedStations[stationName] = true
        UserDefaults.standard.set(visitedStations, forKey: visitedStationsKey)
        
        // Optional: also update lines automatically
        if let station = stations.first(where: { $0.name == stationName }) {
            markLinesVisited(for: station.lines)
        }
        
        objectWillChange.send()
    }
    
    func markLinesVisited(for lines: [String]) {
        var visitedLines = UserDefaults.standard.dictionary(forKey: visitedLinesKey) as? [String: Bool] ?? [:]
        for line in lines {
            visitedLines[line] = true
        }
        UserDefaults.standard.set(visitedLines, forKey: visitedLinesKey)
    }
    
    // MARK: - Line progress
    func visitedStationsCount(for line: String) -> Int {
        let visitedStations = UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
        let stationsOnLine = stations.filter { $0.lines.contains(line) }
        return stationsOnLine.filter { visitedStations[$0.name] == true }.count
    }
    
    func totalStationsCount(for line: String) -> Int {
        return stations.filter { $0.lines.contains(line) }.count
    }
    
    func isLineVisited(_ line: String) -> Bool {
        return visitedStationsCount(for: line) > 0
    }
    
    func allLines() -> [String] {
        return Array(Set(stations.flatMap { $0.lines })).sorted()
    }
}

