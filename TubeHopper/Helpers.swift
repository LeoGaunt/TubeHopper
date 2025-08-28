//
//  Helpers.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

func raptorShortestPath(from start: String, to end: String, stations: [Station], maxTransfers: Int = 10) -> [PathStep]? {
    var earliest: [String: (transfers: Int, prev: (station: String, line: String)?)] = [:]
    
    // Initialize
    for station in stations {
        earliest[station.name] = (transfers: Int.max, prev: nil)
    }
    earliest[start] = (transfers: 0, prev: nil)
    
    var markedStations: Set<String> = [start]
    
    for _ in 0..<maxTransfers {
        var nextMarked: Set<String> = []
        
        for stationName in markedStations {
            guard let station = stations.first(where: { $0.name == stationName }) else { continue }
            let currentTransfers = earliest[stationName]!.transfers
            
            for conn in station.connections {
                let nextTransfers = (earliest[stationName]!.prev?.line == conn.line || earliest[stationName]!.prev == nil)
                    ? currentTransfers
                    : currentTransfers + 1
                
                if nextTransfers < earliest[conn.station]!.transfers {
                    earliest[conn.station] = (transfers: nextTransfers, prev: (station: stationName, line: conn.line))
                    nextMarked.insert(conn.station)
                }
            }
        }
        
        if nextMarked.isEmpty { break }
        markedStations = nextMarked
    }
    
    // Reconstruct path
    var path: [PathStep] = []
    var currentName = end
    while let info = earliest[currentName]?.prev {
        guard let station = stations.first(where: { $0.name == currentName }) else { break }
        path.insert(PathStep(station: station, line: info.line, changeCount: earliest[currentName]!.transfers), at: 0)
        currentName = info.station
    }
    
    if path.isEmpty { return nil }
    return path
}
