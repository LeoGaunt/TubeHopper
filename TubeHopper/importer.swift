//
//  importer.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//

import Foundation

func loadStations() -> [Station] {
    guard let url = Bundle.main.url(forResource: "tube_network_clean_new", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        return []
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([Station].self, from: data)
    } catch {
        print("Failed to decode stations.json:", error)
        return []
    }
}

func loadTubeData() -> TubeData {
    guard let url = Bundle.main.url(forResource: "tube_data_clean", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        return TubeData(lines: [], stations: [])
    }
    
    do {
        return try JSONDecoder().decode(TubeData.self, from: data)
    } catch {
        print("Error decoding tube data: \(error)")
        return TubeData(lines: [], stations: [])
    }
}

