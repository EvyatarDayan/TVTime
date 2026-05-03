//
//  RadioView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct RadioView: View {
    @State private var radioChannels: [RadioChannel] = []
    
    @State private var streamStatus: [String: Bool] = [:]
    @State private var isValidating = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    
    private let defaultChannels: [RadioChannel] = [
        RadioChannel(name: "גלגלצ", streamURL: "https://glzwizzlv.bynetcdn.com/glglz_mp3", imageName: "galgalatz"),
        RadioChannel(name: "גלי צה\"ל", streamURL: "https://glzwizzlv.bynetcdn.com/glz_mp3?awCollectionId=misc&awEpisodeId=glz", imageName: "galey_tzahal"),
        RadioChannel(name: "רדיו 88", streamURL: "https://29073.live.streamtheworld.com/KAN_88.mp3", imageName: "radio88"),
        RadioChannel(name: "רדיו תל אביב", streamURL: "https://102.livecdn.biz/102fm_aac", imageName: "radio_tel_aviv"),
        RadioChannel(name: "רדיו 103", streamURL: "https://cdn.cybercdn.live/103FM/Live/icecast.audio", imageName: "radio103"),
        RadioChannel(name: "רדיוס 100", streamURL: "https://cdn.cybercdn.live/Radios_100FM/Audio/icecast.audio", imageName: "radius"),
        RadioChannel(name: "רשת גימל", streamURL: "https://27873.live.streamtheworld.com/KAN_GIMMEL.mp3?dist=radio2net", imageName: "gimel"),
        RadioChannel(name: "אקו 99", streamURL: "https://eco01.livecdn.biz/ecolive/99fm_aac/icecast.audio", imageName: "eco99")
    ]
    
    var filteredChannels: [RadioChannel] {
        if searchText.isEmpty {
            return radioChannels
        } else {
            return radioChannels.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundPrimary.ignoresSafeArea()
                
                List {
                if filteredChannels.isEmpty && !searchText.isEmpty {
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
                
                ForEach(filteredChannels) { channel in
                    ZStack {
                        NavigationLink(destination: RadioPlayerView(channel: channel)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack(spacing: 16) {
                            // Radio logo
                            if let imageName = channel.imageName {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } else {
                                Image(systemName: "radio")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(channel.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if favoritesManager.isRadioChannelFavorite(channel) {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                                
                                if let streamURL = channel.streamURL {
                                    if let isAvailable = streamStatus[channel.id] {
                                        if isAvailable {
                                            Text("Live Stream Available")
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
                                    Text("No Stream Available")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            Spacer()
                            
                            if let streamURL = channel.streamURL {
                                if let isAvailable = streamStatus[channel.id] {
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
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.red)
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
                .onMove(perform: moveChannel)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Radio")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search stations")
            .onAppear {
                loadChannels()
                validateStreams()
                syncFavoritesData()
            }
        }
    }
    
    private func loadChannels() {
        if let savedData = UserDefaults.standard.data(forKey: "radioChannelsOrder"),
           let savedChannels = try? JSONDecoder().decode([RadioChannel].self, from: savedData) {
            radioChannels = savedChannels
        } else {
            radioChannels = defaultChannels
        }
    }
    
    private func syncFavoritesData() {
        // Update favorite radio channel data with current channel info
        for channel in radioChannels {
            favoritesManager.updateRadioChannelData(channel)
        }
    }
    
    private func saveChannels() {
        if let encoded = try? JSONEncoder().encode(radioChannels) {
            UserDefaults.standard.set(encoded, forKey: "radioChannelsOrder")
        }
    }
    
    private func moveChannel(from source: IndexSet, to destination: Int) {
        radioChannels.move(fromOffsets: source, toOffset: destination)
        saveChannels()
    }
    
    private func validateStreams() {
        guard !isValidating else { return }
        isValidating = true
        
        for channel in radioChannels {
            if let streamURL = channel.streamURL {
                StreamValidator.shared.validateStream(urlString: streamURL) { isAvailable in
                    streamStatus[channel.id] = isAvailable
                }
            }
        }
    }
}
