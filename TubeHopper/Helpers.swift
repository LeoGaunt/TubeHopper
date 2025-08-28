//
//  Helpers.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

func shortestPathFewestChanges(from startName: String, to endName: String, stations: [Station]) -> [PathStep]? {
    var queue: [[PathStep]] = []
    var visited: [String: Int] = [:] // "StationName|Line" : min changeCount

    guard let startStation = stations.first(where: { $0.name == startName }) else { return nil }

    for line in startStation.lines {
        let step = PathStep(station: startStation, line: line, changeCount: 0)
        queue.append([step])
        visited["\(startStation.name)|\(line)"] = 0
    }

    while !queue.isEmpty {
        let path = queue.removeFirst()
        guard let currentStep = path.last else { continue }
        let currentStation = currentStep.station

        if currentStation.name == endName {
            return path
        }

        for connection in currentStation.connections {
            guard let nextStation = stations.first(where: { $0.name == connection.station }) else { continue }

            let nextLine = connection.line
            let changeCount = currentStep.line == nextLine ? currentStep.changeCount : currentStep.changeCount + 1
            let key = "\(nextStation.name)|\(nextLine)"

            if let visitedCount = visited[key], visitedCount <= changeCount {
                continue // already visited with fewer changes
            }

            visited[key] = changeCount
            var newPath = path
            newPath.append(PathStep(station: nextStation, line: nextLine, changeCount: changeCount))
            queue.append(newPath)
        }
    }

    return nil
}

