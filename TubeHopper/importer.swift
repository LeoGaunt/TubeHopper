//
//  importer.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

func loadJSONData(filename: String) -> Data? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else { return nil }
    return try? Data(contentsOf: url)
}

func loadStations() -> [Station] {
    guard let url = Bundle.main.url(forResource: "tube_network_clean", withExtension: "json") else {
        print("JSON file not found")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let stations = try decoder.decode([Station].self, from: data) // directly decode array
        print("Loaded \(stations.count) stations")
        return stations
    } catch {
        print("Failed to decode JSON: \(error)")
        return []
    }
}

