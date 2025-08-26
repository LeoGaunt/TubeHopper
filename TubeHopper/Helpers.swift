//
//  Helpers.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

func shortestPathWithLines(from startName: String, to endName: String, stations: [Station]) -> [PathStep]? {
    var queue: [[PathStep]] = []
    var visited: Set<String> = [] // format: "StationName|Line"

    guard let startStation = stations.first(where: { $0.name == startName }) else { return nil }

    // Initialize queue with all lines from start station
    for line in startStation.lines {
        let step = PathStep(station: startStation, line: line)
        queue.append([step])
        visited.insert("\(startStation.name)|\(line)")
    }

    while !queue.isEmpty {
        let path = queue.removeFirst()
        guard let currentStep = path.last else { continue }
        let currentStation = currentStep.station

        if currentStation.name == endName {
            return path
        }

        for connection in currentStation.connections {
            let visitKey = "\(connection.station)|\(connection.line)"
            if !visited.contains(visitKey),
               let nextStation = stations.first(where: { $0.name == connection.station }) {
                visited.insert(visitKey)
                var newPath = path
                newPath.append(PathStep(station: nextStation, line: connection.line))
                queue.append(newPath)
            }
        }
    }

    return nil
}
