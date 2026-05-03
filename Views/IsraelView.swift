//
//  IsraelView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct IsraelView: View {
    @State private var channels: [Channel] = []
    
    @State private var streamStatus: [String: Bool] = [:] // Track stream availability
    @State private var isValidating = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    
    private let defaultChannels: [Channel] = [
        Channel(name: "רשת 13", streamURL: "https://d2xg1g9o5vns8m.cloudfront.net/out/v1/0855d703f7d5436fae6a9c7ce8ca5075/index.m3u8", imageName: "reshet13"),
        
        Channel(name: "רשת קומדיות", streamURL: "https://d15ds134q59udk.cloudfront.net/media/3b45de9e-c944-4fdc-a344-7c3042b5b104/profile/1/profileManifest.m3u8?_uid=6e9dfac5-8d9f-41a6-b80a-e9d80c56b6fb&rK=a8&_did=f4e0b3b7719e9ec5c95b1baf9e29ec7918c1692b", imageName: "reshet13"),
        
        Channel(name: "רשת ראליטי", streamURL: "https://d2dffl3588mvfk.cloudfront.net/out/v1/d8e15050ca4148aab0ee387a5e2eb46b/index_2.m3u8", imageName: "reshet13"),
        
        Channel(name: "קשת 12", streamURL: "https://mako-streaming.akamaized.net/stream/hls/live/2033791/k12n12wad/profile/1/hdntl=exp=1761431851~acl=%2f*~data=hdntl~hmac=68a990bf82d0153c0c724ef7c732a98b7ffa707d30c5051aac77f47af0ed7940/profileManifest.m3u8?_uid=79b04230-442f-4b8a-806c-501a7fa504b7&rK=b11&_did=f4e0b3b7719e9ec5c95b1baf9e29ec7918c1692b", imageName: "keshet12"),
        
        Channel(name: "כאן 11", streamURL: "https://kan11w.media.kan.org.il/hls/live/2105694/2105694/master.m3u8", imageName: "kan11"),
        
        Channel(name: "חינוכית", streamURL: "https://kan23.media.kan.org.il/hls/live/2024691/2024691/master.m3u8", imageName: "check1"),
        
        Channel(name: "עכשיו 14", streamURL: "https://youtu.be/Dz4UqOoLk2U", imageName: "C14"),
        
        Channel(name: "ערוץ הכנסת", streamURL: "https://kneset.gostreaming.tv/p2-kneset/_definst_/myStream/chunklist.m3u8", imageName: "kneset"),
        
        Channel(name: "Ynet", streamURL: "https://ynet-live-01.ynet-pic1.yit.co.il/ynet/live_720.m3u8", imageName: "ynet"),
                
        Channel(name: "i24 NEWS", streamURL: "https://bcovlive-a.akamaihd.net/d89ede8094c741b7924120b27764153c/eu-central-1/5377161796001/playlist.m3u8", imageName: "I24NEWS"),
        

        

    ]
    
    var filteredChannels: [Channel] {
        if searchText.isEmpty {
            return channels
        } else {
            return channels.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
                        NavigationLink(destination: ChannelPlayerView(channel: channel)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack(spacing: 16) {
                            // Channel logo
                            if let imageName = channel.imageName {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } else {
                                Image(systemName: "tv")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(channel.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if favoritesManager.isChannelFavorite(channel) {
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
            .navigationTitle("Israeli Channels")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search channels")
            .onAppear {
                loadChannels()
                validateStreams()
                syncFavoritesData()
            }
        }
    }
    
    private func loadChannels() {
        if let savedData = UserDefaults.standard.data(forKey: "israelChannelsOrder"),
           let savedChannels = try? JSONDecoder().decode([Channel].self, from: savedData) {
            channels = savedChannels
        } else {
            channels = defaultChannels
        }
    }
    
    private func syncFavoritesData() {
        // Update favorite channel data with current channel info
        for channel in channels {
            favoritesManager.updateChannelData(channel)
        }
    }
    
    private func saveChannels() {
        if let encoded = try? JSONEncoder().encode(channels) {
            UserDefaults.standard.set(encoded, forKey: "israelChannelsOrder")
        }
    }
    
    private func moveChannel(from source: IndexSet, to destination: Int) {
        channels.move(fromOffsets: source, toOffset: destination)
        saveChannels()
    }
    
    private func validateStreams() {
        guard !isValidating else { return }
        isValidating = true
        
        for channel in channels {
            if let streamURL = channel.streamURL {
                StreamValidator.shared.validateStream(urlString: streamURL) { isAvailable in
                    streamStatus[channel.id] = isAvailable
                }
            }
        }
    }
}

#Preview {
    IsraelView()
}
