//
//  Helpers.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

func shortestPathFewestChanges(from start: String, to end: String, stations: [Station]) -> [PathStep]? {
    // Basically Dijkstra's algorithm with a lexicographic weight
    // Priority queue simulated with array (sorted by transfers, then stops)
    var frontier: [(station: String, line: String?, transfers: Int, stops: Int, path: [PathStep])] = []
    frontier.append((station: start, line: nil, transfers: 0, stops: 0, path: []))
    
    // Best known (transfers, stops) for each station
    var best: [String: (transfers: Int, stops: Int)] = [:]
    for s in stations {
        best[s.name] = (Int.max, Int.max)
    }
    best[start] = (0, 0)
    
    while !frontier.isEmpty {
        // Always pick state with fewest transfers (then stops)
        frontier.sort {
            $0.transfers == $1.transfers
                ? $0.stops < $1.stops
                : $0.transfers < $1.transfers
        }
        let current = frontier.removeFirst()
        
        if current.station == end {
            return current.path
        }
        
        guard let stationObj = stations.first(where: { $0.name == current.station }) else { continue }
        
        for conn in stationObj.connections {
            let nextTransfers = (current.line == conn.line || current.line == nil)
                ? current.transfers
                : current.transfers + 1
            let nextStops = current.stops + 1
            
            let nextStep = PathStep(station: stations.first(where: { $0.name == conn.station })!,
                                    line: conn.line,
                                    transfers: nextTransfers,
                                    stops: nextStops)
            
            if (nextTransfers < best[conn.station]!.transfers) ||
               (nextTransfers == best[conn.station]!.transfers && nextStops < best[conn.station]!.stops) {
                best[conn.station] = (nextTransfers, nextStops)
                var newPath = current.path
                newPath.append(nextStep)
                frontier.append((station: conn.station,
                                 line: conn.line,
                                 transfers: nextTransfers,
                                 stops: nextStops,
                                 path: newPath))
            }
        }
    }
    
    return nil
}
