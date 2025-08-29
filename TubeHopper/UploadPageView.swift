//
//  UploadPageView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 29/08/2025.
//

import SwiftUI

struct UploadPageView: View {
    @EnvironmentObject var store: StationStore
    @State private var showingPicker = false
    @State private var message = "Select a CSV file to upload"
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Upload your TfL CSV")
                .font(.largeTitle)
                .bold()
            
            Button(action: {
                showingPicker = true
            }) {
                Text("Choose CSV File")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            Text(message)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingPicker) {
            CSVPicker { url in
                processCSV(url: url)
            }
        }
    }
    
    // MARK: - CSV Processing
    func processCSV(url: URL) {
        do {
            let csvString = try String(contentsOf: url, encoding: .utf8)
            let journeys = parseTfLCSV(csvString)
            
            for journey in journeys {
                if let pathSteps = shortestPathFewestChanges(from: journey.start, to: journey.end, stations: store.stations) {
                    let routeStations = pathStepsToStationNames(pathSteps)
                    for stationName in routeStations {
                        store.markStationVisited(stationName)
                    }
                }
            }
            
            message = "CSV uploaded successfully! ✅"
        } catch {
            message = "Failed to read CSV: \(error)"
        }
    }
    
    func parseTfLCSV(_ csv: String) -> [(start: String, end: String)] {
        var journeys: [(start: String, end: String)] = []

        let lines = csv.components(separatedBy: "\n")

        for (index, line) in lines.enumerated() {
            // Skip header row
            if index == 0 { continue }

            // Split by comma (CSV)
            let columns = line.components(separatedBy: ",")

            // Journey is column 3 (0-based index 2)
            if columns.count > 2 {
                let journeyColumn = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)

                // Split "Start Station to End Station"
                let parts = journeyColumn.components(separatedBy: " to ")
                if parts.count == 2 {
                    let start = parts[0].replacingOccurrences(of: " \\(London Underground\\)", with: "", options: .regularExpression)
                                      .trimmingCharacters(in: .whitespacesAndNewlines)
                    let end = parts[1].replacingOccurrences(of: " \\(London Underground\\)", with: "", options: .regularExpression)
                                    .trimmingCharacters(in: .whitespacesAndNewlines)

                    journeys.append((start: start, end: end))
                }
            }
        }

        return journeys
    }
}

