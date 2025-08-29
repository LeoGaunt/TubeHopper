//
//  LineDetailView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 29/08/2025.
//

import SwiftUI

struct LineDetailView: View {
    @EnvironmentObject var store: StationStore
    let line: String
    
    @State private var showAlert = false
    @State private var selectedStation: Station? = nil
    
    var body: some View {
        VStack {
            // Progress at the top
            let visited = store.visitedStationsCount(for: line)
            let total = store.totalStationsCount(for: line)
            Text("\(visited)/\(total) stations visited")
                .font(.headline)
                .padding()
            
            List {
                ForEach(store.stations.filter { $0.lines.contains(line) }) { station in
                    HStack {
                        Text(station.name)
                        Spacer()
                        Image(systemName: isStationVisited(station) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isStationVisited(station) ? .green : .gray)
                            .onTapGesture {
                                selectedStation = station
                                showAlert = true
                            }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle(line)
        .alert(isPresented: $showAlert) {
            guard let station = selectedStation else { return Alert(title: Text("Error")) }
            
            let alreadyVisited = isStationVisited(station)
            return Alert(
                title: Text(alreadyVisited ? "Unmark Station?" : "Mark Station?"),
                message: Text("Are you sure you want to \(alreadyVisited ? "unmark" : "mark") '\(station.name)' as visited?"),
                primaryButton: .destructive(Text("Yes")) {
                    toggleStationVisited(station)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func isStationVisited(_ station: Station) -> Bool {
        let visitedStations = UserDefaults.standard.dictionary(forKey: "visitedStations") as? [String: Bool] ?? [:]
        return visitedStations[station.name] == true
    }
    
    private func toggleStationVisited(_ station: Station) {
        var visitedStations = UserDefaults.standard.dictionary(forKey: "visitedStations") as? [String: Bool] ?? [:]
        let currentlyVisited = visitedStations[station.name] ?? false
        visitedStations[station.name] = !currentlyVisited
        UserDefaults.standard.set(visitedStations, forKey: "visitedStations")
        
        // Optional: update lines automatically
        if !currentlyVisited {
            store.markLinesVisited(for: station.lines)
        }
        
        store.objectWillChange.send()
    }
}


