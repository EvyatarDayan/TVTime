//
//  FavoritesView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct FavoritesView: View {
    @State private var streamStatus: [String: Bool] = [:]
    @State private var isValidating = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
                ScrollView {
                LazyVStack(spacing: 0) {
                    // TV Channel Favorites Section
                        if !favoritesManager.favoriteChannels.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TV Channels")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                            
                            VStack(spacing: 16) {
                            ForEach(favoritesManager.favoriteChannels) { channel in
                                    NavigationLink(destination: ChannelPlayerView(channel: channel)) {
                                        FavoriteChannelCard(
                                            channel: channel,
                                            isRadio: false,
                                            streamStatus: streamStatus[channel.id]
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Radio Channel Favorites Section
                    if !favoritesManager.favoriteRadioChannels.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Radio Stations")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                                .padding(.top, favoritesManager.favoriteChannels.isEmpty ? 16 : 24)
                            
                            VStack(spacing: 16) {
                                ForEach(favoritesManager.favoriteRadioChannels) { radioChannel in
                                    NavigationLink(destination: RadioPlayerView(channel: radioChannel)) {
                                        FavoriteRadioCard(
                                            channel: radioChannel,
                                            streamStatus: streamStatus[radioChannel.id]
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                            // Empty state when no favorites
                    if favoritesManager.favoriteChannels.isEmpty && favoritesManager.favoriteRadioChannels.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "heart")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                
                                Text("No Favorites Yet")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Add channels to your favorites by tapping the heart button while watching them.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding(40)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(themeManager.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                validateStreams()
            }
            .onChange(of: favoritesManager.favoriteChannels.count) { _ in
                validateStreams()
            }
            .onChange(of: favoritesManager.favoriteRadioChannels.count) { _ in
                validateStreams()
            }
        }
    }
    
    
    private func deleteTVChannel(at offsets: IndexSet) {
        for index in offsets {
            let channel = favoritesManager.favoriteChannels[index]
            favoritesManager.toggleChannelFavorite(channel)
        }
    }
    
    private func deleteRadioChannel(at offsets: IndexSet) {
        for index in offsets {
            let channel = favoritesManager.favoriteRadioChannels[index]
            favoritesManager.toggleRadioChannelFavorite(channel)
        }
    }
    
    private func validateStreams() {
        guard !isValidating else { return }
        isValidating = true
        
        // Clear previous validation results
        streamStatus.removeAll()
        
        // Convert radio channels to Channel type for unified processing
        let radioAsChannels = favoritesManager.favoriteRadioChannels.map { radioChannel in
            Channel(name: radioChannel.name, streamURL: radioChannel.streamURL, imageName: radioChannel.imageName)
        }
        
        let allChannels = favoritesManager.favoriteChannels + radioAsChannels
        
        var validationCount = 0
        let totalChannels = allChannels.count
        
        for channel in allChannels {
            if let streamURL = channel.streamURL {
                StreamValidator.shared.validateStream(urlString: streamURL) { available in
                    streamStatus[channel.id] = available
                    validationCount += 1
                    
                    // Reset isValidating when all validations are complete
                    if validationCount >= totalChannels {
                        isValidating = false
                    }
                }
            } else {
                // No stream URL, mark as unavailable
                streamStatus[channel.id] = false
                validationCount += 1
                
                if validationCount >= totalChannels {
                    isValidating = false
                }
            }
        }
        
        // If no channels to validate, reset the flag immediately
        if totalChannels == 0 {
            isValidating = false
        }
    }
}

// MARK: - Favorite Channel Card
struct FavoriteChannelCard: View {
    let channel: Channel
    let isRadio: Bool
    let streamStatus: Bool?
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack(alignment: .center) {
            // Background image (blurred) - use backgroundImageName if available, fallback to imageName
            if let backgroundImage = channel.backgroundImageName ?? channel.imageName {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 220)
                    .clipped()
                    .blur(radius: 8)
            } else {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 220)
            }
            
            // Dark overlay
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(height: 220)
            
            // Channel name - centered
            VStack {
                Spacer()
                Text(channel.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .frame(height: 220)
            
            // Status indicator - bottom left
            VStack {
                Spacer()
                HStack {
                    HStack(spacing: 6) {
                        if let status = streamStatus {
                            if status {
                                Image(systemName: "play.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("Live")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Text("Offline")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                            }
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.7)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.bottom, 12)
            }
            .frame(height: 220)
            
            // Heart icon - top right
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(10)
                }
                Spacer()
            }
            .frame(height: 220)
        }
        .frame(height: 220)
        .contentShape(Rectangle())
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue, lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Favorite Radio Card
struct FavoriteRadioCard: View {
    let channel: RadioChannel
    let streamStatus: Bool?
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack(alignment: .center) {
            // Background image (blurred) - use backgroundImageName if available, fallback to imageName
            if let backgroundImage = channel.backgroundImageName ?? channel.imageName {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 220)
                    .clipped()
                    .blur(radius: 8)
            } else {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.6), Color.pink.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 220)
            }
            
            // Dark overlay
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(height: 220)
            
            // Channel name - centered
            VStack {
                Spacer()
                Text(channel.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .frame(height: 220)
            
            // Status indicator - bottom left
            VStack {
                Spacer()
                HStack {
                    HStack(spacing: 6) {
                        if let status = streamStatus {
                            if status {
                                Image(systemName: "play.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("Live")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Text("Offline")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                            }
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.7)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.bottom, 12)
            }
            .frame(height: 220)
            
            // Heart icon - top right
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(10)
                }
                Spacer()
            }
            .frame(height: 220)
        }
        .frame(height: 220)
        .contentShape(Rectangle())
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue, lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(ThemeManager.shared)
}
