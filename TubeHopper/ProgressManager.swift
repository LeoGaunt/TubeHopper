//
//  ProgressManager.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 29/08/2025.
//

import Foundation

class ProgressManager {
    static let shared = ProgressManager()
    
    private let visitedLinesKey = "visitedLines"
    private let visitedStationsKey = "visitedStations"
    private let initializedKey = "progressInitialized"
    
    // MARK: - Visited Lines
    func markLineVisited(_ line: String) {
        var visited = getVisitedLines()
        visited[line] = true
        UserDefaults.standard.set(visited, forKey: visitedLinesKey)
    }
    
    func getVisitedLines() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: visitedLinesKey) as? [String: Bool] ?? [:]
    }
    
    func hasVisitedLine(_ line: String) -> Bool {
        return getVisitedLines()[line] ?? false
    }
    
    // MARK: - Visited Stations
    func markStationVisited(_ station: String) {
        var visited = getVisitedStations()
        visited[station] = true
        UserDefaults.standard.set(visited, forKey: visitedStationsKey)
    }
    
    func getVisitedStations() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: visitedStationsKey) as? [String: Bool] ?? [:]
    }
    
    func hasVisitedStation(_ station: String) -> Bool {
        return getVisitedStations()[station] ?? false
    }
}
