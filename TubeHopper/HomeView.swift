//
//  HomeView.swift
//  TubeHopper
//
//  Created by Leo Gaunt on 29/08/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: StationStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    
                    // Two-column grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        // Line cards
                        ForEach(store.allLines(), id: \.self) { line in
                            let visited = store.visitedStationsCount(for: line)
                            let total = store.totalStationsCount(for: line)
                            let isVisited = store.isLineVisited(line)
                            
                            NavigationLink(destination: LineDetailView(line: line)) {
                                LineCardView(
                                    line: line,
                                    visitedStations: visited,
                                    totalStations: total,
                                    isVisited: isVisited
                                )
                            }
                            .buttonStyle(PlainButtonStyle()) // removes default NavigationLink styling
                        }
                        
                        // Upload card
                        NavigationLink(destination: UploadPageView()) {
                            VStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .foregroundColor(.blue)
                                Text("Upload TfL CSV")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                            .padding(6)
                        }
                        
                        // Settings Card
                        NavigationLink(destination: SettingsPageView()) {
                            VStack(spacing: 10) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .foregroundColor(.purple)
                                Text("Settings")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                            .padding(6)
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
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
