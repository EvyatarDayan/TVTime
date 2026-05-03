//
//  SeriesDetailView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-25.
//

import SwiftUI

struct SeriesDetailView: View {
    let series: Series
    @State private var streamStatus: [String: Bool] = [:]
    @State private var isValidating = false
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    
    var filteredEpisodes: [Episode] {
        if searchText.isEmpty {
            return series.episodes
        } else {
            return series.episodes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.backgroundPrimary.ignoresSafeArea()
            
            List {
                if filteredEpisodes.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No results found")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Try adjusting your search")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(40)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                
                ForEach(filteredEpisodes) { episode in
                    // Convert episode to channel for player compatibility
                    let channel = Channel(
                        name: episode.name,
                        streamURL: episode.streamURL,
                        imageName: episode.imageName,
                        backgroundImageName: episode.backgroundImageName
                    )
                    
                    ZStack {
                        NavigationLink(destination: ChannelPlayerView(channel: channel)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack(spacing: 16) {
                            // Episode image or number badge
                            if let imageName = episode.imageName {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                    
                                    // Episode number overlay
                                    Text("\(episode.episodeNumber)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(4)
                                        .padding(4)
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                    
                                    Text("\(episode.episodeNumber)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(episode.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                
                                if let streamURL = episode.streamURL {
                                    if let isAvailable = streamStatus[episode.id] {
                                        if isAvailable {
                                            Text("Stream Available")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        } else {
                                            Text("No Stream Available")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    } else {
                                        Text("Checking...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    Text("URL Not Set")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            Spacer()
                            
                            if let streamURL = episode.streamURL {
                                if let isAvailable = streamStatus[episode.id] {
                                    if isAvailable {
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.title2)
                                    } else {
                                        Image(systemName: "exclamationmark.circle")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                    }
                                } else {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                }
                            } else {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                            }
                        }
                        .padding(16)
                        .background(themeManager.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(series.name)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search episodes")
        .onAppear {
            validateStreams()
        }
    }
    
    private func validateStreams() {
        guard !isValidating else { return }
        isValidating = true
        
        for episode in series.episodes {
            if let streamURL = episode.streamURL {
                StreamValidator.shared.validateStream(urlString: streamURL) { isAvailable in
                    streamStatus[episode.id] = isAvailable
                }
            }
        }
    }
}

#Preview {
    SeriesDetailView(series: Series(
        name: "הרמון",
        imageName: "harmon",
        episodes: [
            Episode(episodeNumber: 1, name: "הרמון, עונה 1, פרק 1: בכורה"),
            Episode(episodeNumber: 2, name: "הרמון, עונה 1, פרק 2: משפחה חדשה")
        ]
    ))
}

