//
//  GlobalView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct GlobalView: View {
    @State private var globalChannels: [Channel] = []
    
    @State private var streamStatus: [String: Bool] = [:]
    @State private var isValidating = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    
    private let defaultChannels: [Channel] = [
        Channel(name: "FOX NEWS", streamURL: "https://fl7.moveonjoy.com/FOX_NEWS_CHANNEL/index.m3u8", imageName: "fox"),
        Channel(name: "ABC NEWS", streamURL: "https://content.uplynk.com/channel/3324f2467c414329b3b0cc5cd987b6be.m3u8", imageName: "abc"),
        Channel(name: "SKY NEWS", streamURL: "https://www.youtube-nocookie.com/embed/YDvsBbKfLPA?autoplay=1&mute=0&enablejsapi=1&showinfo=0&controls=1", imageName: "sky"),
        Channel(name: "Al Jazeera", streamURL: "https://live-hls-apps-aje-fa.getaj.net/AJE/index.m3u8", imageName: "Al_Jazeera"),
        Channel(name: "CNBC", streamURL: "https://fl7.moveonjoy.com/CNBC/index.m3u8", imageName: "cnbc"),
        
        Channel(name: "CNN", streamURL: "https://youtu.be/Wekll2K87xw?si=84fN83DkiNjaTNnP", imageName: "cnn"),
        
        Channel(name: "EURO NEWS", streamURL: "https://www.youtube.com/embed/pykpO5kQJ98?autoplay=1&mute=1&enablejsapi=1&showinfo=0&embed_config=%7B%22primaryThemeColor%22%3A%22%23005587%22%2C%22autonavRelatedVideos%22%3Atrue%2C%22enableIma%22%3Atrue%2C%22adsConfig%22%3A%7B%22disableAds%22%3Atrue%2C%22adTagParameters%22%3A%7B%22iu%22%3A%22%2F6458%2Fen_euronews_new%2Flive%22%2C%22cust_params%22%3A%22lng%3Den%26page%3Dlive%26IDS%3D0%26qt_loaded%3Dabs%252Cbsc%252Cids%26ABS%3D%26BSC%3D84122001%252C84012001%252C84091001%252C87012038%252C84011001%252C84092002%252C84121001%26player_type%3Dpfp%22%7D%7D%7D&origin=https%3A%2F%2Fwww.euronews.com&widgetid=1&forigin=https%3A%2F%2Fwww.euronews.com%2Flive%3Futm_source%3Dchatgpt.com&aoriginsup=1&gporigin=https%3A%2F%2Fchatgpt.com%2F&vf=3", imageName: "euronews"),
        Channel(name: "BBC", streamURL: "https://vs-hls-push-ww-live.akamaized.net/x=4/i=urn:bbc:pips:service:bbc_news_channel_hd/mobile_wifi_main_hd_abr_v2.m3u8", imageName: "bbc"),
        Channel(name: "Reuters", streamURL: "https://amg00453-reuters-amg00453c1-rakuten-uk-2110.playouts.now.amagi.tv/playlist/amg00453-reuters-reuters-rakutenuk/playlist.m3u8", imageName: "reuters"),
        
        Channel(name: "Test", streamURL: "https://www.kan.org.il/content/kan/kan-11/p-12832/s5/809157/", imageName: "test"),
    ]
    
    var filteredChannels: [Channel] {
        if searchText.isEmpty {
            return globalChannels
        } else {
            return globalChannels.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
            .navigationTitle("Global Channels")
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
        if let savedData = UserDefaults.standard.data(forKey: "globalChannelsOrder"),
           let savedChannels = try? JSONDecoder().decode([Channel].self, from: savedData) {
            globalChannels = savedChannels
        } else {
            globalChannels = defaultChannels
        }
    }
    
    private func syncFavoritesData() {
        // Update favorite channel data with current channel info
        for channel in globalChannels {
            favoritesManager.updateChannelData(channel)
        }
    }
    
    private func saveChannels() {
        if let encoded = try? JSONEncoder().encode(globalChannels) {
            UserDefaults.standard.set(encoded, forKey: "globalChannelsOrder")
        }
    }
    
    private func moveChannel(from source: IndexSet, to destination: Int) {
        globalChannels.move(fromOffsets: source, toOffset: destination)
        saveChannels()
    }
    
    private func validateStreams() {
        guard !isValidating else { return }
        isValidating = true
        
        for channel in globalChannels {
            if let streamURL = channel.streamURL {
                StreamValidator.shared.validateStream(urlString: streamURL) { isAvailable in
                    streamStatus[channel.id] = isAvailable
                }
            }
        }
    }
}
