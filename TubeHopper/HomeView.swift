//
//  HomeView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 29/08/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: StationLineStore
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(store.lines, id: \.self) { line in
                        let visitedStations = visitedCount(for: line)
                        let totalStations = totalCount(for: line)
                        let isVisited = visitedStations > 0
                        
                        LineCardView(
                            line: line,
                            visitedStations: visitedStations,
                            totalStations: totalStations,
                            isVisited: isVisited
                        )
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Helpers
    
    func visitedCount(for line: String) -> Int {
        // TODO: look up how many stations visited on this line from UserDefaults
        return 0
    }
    
    func totalCount(for line: String) -> Int {
        // TODO: count how many stations belong to this line
        return 100 // placeholder
    }
}

struct LineCardView: View {
    let line: String
    let visitedStations: Int
    let totalStations: Int
    let isVisited: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            // Top strip
            Rectangle()
                .fill(LineColors.colors[line] ?? .gray)
                .frame(height: 6)
                .cornerRadius(3)
                .padding(.horizontal, 10)
                .padding(.top, 8)
            
            // Line name, aligned with rectangle
            Text(line)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            
            // Emoji + count, stays centered
            HStack {
                Text(isVisited ? "✅" : "❌")
                    .font(.largeTitle)
                Text("\(visitedStations)/\(totalStations)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
        .padding(6)
    }
}

struct LineColors {
    static let colors: [String: Color] = [
        "Bakerloo": .brown,
        "Central": .red,
        "Circle": .yellow,
        "District": .green,
        "Hammersmith-City": .pink,
        "Jubilee": .gray,
        "Metropolitan": .purple,
        "Northern": .black,
        "Piccadilly": .blue,
        "Victoria": .cyan,
        "Waterloo-City": .teal
    ]
}
