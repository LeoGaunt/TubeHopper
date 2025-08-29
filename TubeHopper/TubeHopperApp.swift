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
    
    // UserDefaults keys
    private let visitedStationsKey = "visitedStations"
    private let passedThroughStationsKey = "passedThroughStations"
    private let visitedLinesKey = "visitedLines"
    private let initializedKey = "progressInitialized"
    
    init() {
        self.stations = loadStations().sorted { $0.name < $1.name }
        initializeDefaultsIfNeeded()
    }
    
    // MARK: - UserDefaults initialization
    func initializeDefaultsIfNeeded() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: initializedKey) {
            // Mark all stations as not visited or passed through
            let stationDict = Dictionary(uniqueKeysWithValues: stations.map { ($0.name, false) })
            defaults.set(stationDict, forKey: visitedStationsKey)
            defaults.set(stationDict, forKey: passedThroughStationsKey)
            
            // Mark all lines as not visited
            let allLines = Set(stations.flatMap { $0.lines })
            let lineDict = Dictionary(uniqueKeysWithValues: allLines.map { ($0, false) })
            defaults.set(lineDict, forKey: visitedLinesKey)
            
            defaults.set(true, forKey: initializedKey)
        }
    }
    
    // MARK: - Station state
    func isStationVisited(_ station: Station) -> Bool {
        let visited = UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
        return visited[station.name] == true
    }
    
    func isStationPassedThrough(_ station: Station) -> Bool {
        let passed = UserDefaults.standard.dictionary(forKey: passedThroughStationsKey) as? [String: Bool] ?? [:]
        return passed[station.name] == true
    }
    
    func markStationVisited(_ stationName: String) {
        var visited = UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
        visited[stationName] = true
        UserDefaults.standard.set(visited, forKey: visitedStationsKey)
        
        if let station = stations.first(where: { $0.name == stationName }) {
            markLinesVisited(for: station.lines)
        }
        
        objectWillChange.send()
    }
    
    func markStationPassedThrough(_ stationName: String) {
        var passed = UserDefaults.standard.dictionary(forKey: passedThroughStationsKey) as? [String: Bool] ?? [:]
        passed[stationName] = true
        UserDefaults.standard.set(passed, forKey: passedThroughStationsKey)
        
        objectWillChange.send()
    }
    
    func toggleStationVisited(_ stationName: String) {
        var visited = UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
        let current = visited[stationName] ?? false
        visited[stationName] = !current
        UserDefaults.standard.set(visited, forKey: visitedStationsKey)
        objectWillChange.send()
    }
    
    func toggleStationPassedThrough(_ stationName: String) {
        var passed = UserDefaults.standard.dictionary(forKey: passedThroughStationsKey) as? [String: Bool] ?? [:]
        let current = passed[stationName] ?? false
        passed[stationName] = !current
        UserDefaults.standard.set(passed, forKey: passedThroughStationsKey)
        objectWillChange.send()
    }
    
    // MARK: - Line state
    func markLinesVisited(for lines: [String]) {
        var visitedLines = UserDefaults.standard.dictionary(forKey: visitedLinesKey) as? [String: Bool] ?? [:]
        for line in lines {
            visitedLines[line] = true
        }
        UserDefaults.standard.set(visitedLines, forKey: visitedLinesKey)
    }
    
    func visitedStationsCount(for line: String) -> Int {
        let visited = UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
        let stationsOnLine = stations.filter { $0.lines.contains(line) }
        return stationsOnLine.filter { visited[$0.name] == true }.count
    }
    
    func passedThroughStationsCount(for line: String) -> Int {
        let passed = UserDefaults.standard.dictionary(forKey: passedThroughStationsKey) as? [String: Bool] ?? [:]
        let stationsOnLine = stations.filter { $0.lines.contains(line) }
        return stationsOnLine.filter { passed[$0.name] == true }.count
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

