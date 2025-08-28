//
//  Structs.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

class StationData {
    static let shared: [Station] = {
        return loadStations().sorted(by: { $0.name < $1.name })
    }()
}

struct Station: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let lines: [String]
    var connections: [ConnectionInfo]
}

struct ConnectionInfo: Codable, Hashable {
    let station: String   // name of the connected station
    let line: String      // line that connects the two stations
}

struct Line: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let colorHex: String
    let stations: [Station]
}

struct Connection: Codable {
    let from: String 
    let to: String
    let line: String
    let travelTime: Int
}

struct PathStep: Identifiable {
    let id = UUID()
    let station: Station
    let line: String
    let changeCount: Int // total number of line changes so far - so can be used as a penalty
}
