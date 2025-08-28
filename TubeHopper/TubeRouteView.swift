//
//  TubeRouteView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 25/08/2025.
//


import SwiftUI

struct TubeRouteView: View {
    private let stations = StationData.shared
    
    @State private var startStation: String
    @State private var endStation: String
    @State private var path: [PathStep] = []

    init() {
        let first = stations.first?.name ?? ""
        let last = stations.last?.name ?? first
        _startStation = State(initialValue: first)
        _endStation = State(initialValue: last)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Start Station", selection: $startStation) {
                    ForEach(stations, id: \.name) { station in
                        Text(station.name).tag(station.name)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("End Station", selection: $endStation) {
                    ForEach(stations, id: \.name) { station in
                        Text(station.name).tag(station.name)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Button("Find Shortest Path") {
                    path = shortestPathFewestChanges(
                        from: startStation,
                        to: endStation,
                        stations: stations
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
                            ForEach(Array(path.enumerated()), id: \.element.id) { index, step in
                                HStack {
                                    Text(step.station.name)
                                        .bold()
                                    if index > 0 && step.line != path[index - 1].line {
                                        Text("(Change to \(step.line))")
                                            .foregroundColor(.red)
                                            .italic()
                                    } else {
                                        Text("via \(step.line)")
                                            .foregroundColor(.gray)
                                    }
                                }
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
        }
    }
}
