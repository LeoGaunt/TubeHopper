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
    @State private var actionType: ActionType = .visited
    
    enum ActionType {
        case visited, passedThrough
    }
    
    var body: some View {
        VStack {
            // Progress indicators
            let visitedCount = store.visitedStationsCount(for: line)
            let passedCount = store.passedThroughStationsCount(for: line)
            let totalCount = store.totalStationsCount(for: line)
            
            VStack(spacing: 4) {
                Text("Visited: \(visitedCount)/\(totalCount)")
                    .foregroundColor(.green)
                    .font(.headline)
                Text("Passed Through: \(passedCount)/\(totalCount)")
                    .foregroundColor(.orange)
                    .font(.headline)
            }
            .padding()
            
            // Station list
            List {
                ForEach(store.stations.filter { $0.lines.contains(line) }) { station in
                    HStack {
                        Text(station.name)
                        Spacer()
                        
                        // Visited checkmark
                        Image(systemName: store.isStationVisited(station) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.green)
                            .onTapGesture {
                                selectedStation = station
                                actionType = .visited
                                showAlert = true
                            }
                        
                        // Passed-through checkmark
                        Image(systemName: store.isStationPassedThrough(station) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.orange)
                            .onTapGesture {
                                selectedStation = station
                                actionType = .passedThrough
                                showAlert = true
                            }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle(line)
        .alert(isPresented: $showAlert) {
            guard let station = selectedStation else {
                return Alert(title: Text("Error"), message: Text("No station selected"), dismissButton: .default(Text("OK")))
            }
            
            let alreadySet: Bool
            let titleText: String
            let actionText: String
            
            switch actionType {
            case .visited:
                alreadySet = store.isStationVisited(station)
                titleText = alreadySet ? "Unmark Visited?" : "Mark Visited?"
                actionText = alreadySet ? "unmark" : "mark"
            case .passedThrough:
                alreadySet = store.isStationPassedThrough(station)
                titleText = alreadySet ? "Unmark Passed Through?" : "Mark Passed Through?"
                actionText = alreadySet ? "unmark" : "mark"
            }
            
            return Alert(
                title: Text(titleText),
                message: Text("Are you sure you want to \(actionText) '\(station.name)'?"),
                primaryButton: .destructive(Text("Yes")) {
                    switch actionType {
                    case .visited:
                        store.toggleStationVisited(station.name)
                    case .passedThrough:
                        store.toggleStationPassedThrough(station.name)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
