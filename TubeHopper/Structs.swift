//
//  Structs.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

// MARK: - Core Models
struct Station: Identifiable, Hashable, Codable {
    var id: String { name }  // use station name as unique ID
    let name: String
    let lines: [String]
    let connections: [ConnectionInfo]
}

struct ConnectionInfo: Codable, Hashable {
    let station: String   // name of the connected station
    let line: String      // line connecting the two stations
}

// MARK: - For Pathfinding
/*struct PathStep: Identifiable, Hashable {
    let id = UUID()
    let station: Station
    let line: String
    let changeCount: Int  // running total of line changes so far
}*/
struct PathStep {
    let station: Station
    let line: String
    let changeCount: Int
}

struct EarliestArrival {
    var arrivalTime: Int
    var line: String?
    var previousStation: String?
}
