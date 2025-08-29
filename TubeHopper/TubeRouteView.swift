//
//  TubeRouteView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//


import SwiftUI

struct TubeRouteView: View {
    @EnvironmentObject var stationStore: StationStore

    @State private var startStation: String = ""
    @State private var endStation: String = ""
    @State private var path: [PathStep] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Start Station", selection: $startStation) {
                    ForEach(stationStore.stations, id: \.name) { station in
                        Text(station.name).tag(station.name)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("End Station", selection: $endStation) {
                    ForEach(stationStore.stations, id: \.name) { station in
                        Text(station.name).tag(station.name)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Button("Find Shortest Path") {
                    path = shortestPathFewestChanges(
                        from: startStation,
                        to: endStation,
                        stations: stationStore.stations
                    ) ?? []
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                if !path.isEmpty {
                    Text("Shortest Path:")
                        .font(.headline)
                        .padding(.top)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(pathRowTexts, id: \.self) { text in
                                Text(text)
                                    .bold()
                            }
                        }
                    }
                } else {
                    Text("No path found or select stations above")
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Tube Route Finder")
            .onAppear {
                if startStation.isEmpty {
                    startStation = stationStore.stations.first?.name ?? ""
                }
                if endStation.isEmpty {
                    endStation = stationStore.stations.last?.name ?? startStation
                }
            }
        }
    }
    
    private var pathRowTexts: [String] {
        guard !path.isEmpty else { return [] }
        
        var rows: [String] = []
        
        for i in path.indices {
            let step = path[i]
            if i > 0 && step.line != path[i - 1].line {
                rows.append("\(step.station.name) (Change to \(step.line))")
            } else {
                rows.append("\(step.station.name) via \(step.line)")
            }
        }
        
        return rows
    }
}
