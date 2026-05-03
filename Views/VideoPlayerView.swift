//
//  VideoPlayerView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let channel: Channel
    @State private var player: AVPlayer?
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var showFullScreenPlayer = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Always show the same background regardless of orientation
            themeManager.backgroundPrimary.ignoresSafeArea()
            
            if let urlString = channel.streamURL,
               let url = URL(string: urlString) {
                VStack {
                    // Channel info header
                    HStack {
                        if let imageName = channel.imageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                        } else {
                            Image(systemName: "tv")
                                .foregroundColor(.blue)
                                .font(.title2)
                                .frame(width: 40, height: 40)
                        }
                        
                        Text(channel.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Heart button for favorites
                        Button(action: {
                            favoritesManager.toggleChannelFavorite(channel)
                        }) {
                            Image(systemName: favoritesManager.isChannelFavorite(channel) ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundColor(favoritesManager.isChannelFavorite(channel) ? .red : .gray)
                        }
                        
                        // Full screen button
                        Button(action: {
                            // Pause the background player before opening full-screen
                            player?.pause()
                            // Enable landscape for full-screen mode
                            AppDelegate.orientationLock = .allButUpsideDown
                            showFullScreenPlayer = true
                        }) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(themeManager.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Video player
                    if let player = player {
                        CustomVideoPlayer(player: player)
                            .onAppear {
                                player.play()
                            }
                            .onDisappear {
                                player.pause()
                            }
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                }
                .onAppear {
                    if player == nil {
                        player = AVPlayer(url: url)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("No Stream Available")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("This channel doesn't have a streaming URL configured yet.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(themeManager.cardBackground)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Lock to portrait when view appears
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            // Restore normal orientation when leaving
            AppDelegate.orientationLock = .portrait
        }
        .fullScreenCover(isPresented: $showFullScreenPlayer) {
            if let urlString = channel.streamURL,
               let url = URL(string: urlString) {
                FullScreenVideoPlayerView(url: url, isPresented: $showFullScreenPlayer)
            }
        }
        .onChange(of: showFullScreenPlayer) { isPresented in
            if !isPresented {
                // When full-screen is dismissed, lock back to portrait
                AppDelegate.orientationLock = .portrait
                // Resume the background player
                player?.play()
            }
        }
    }
}

#Preview {
    NavigationView {
        VideoPlayerView(channel: Channel(name: "Channel 1", streamURL: "https://d2xg1g9o5vns8m.cloudfront.net/out/v1/0855d703f7d5436fae6a9c7ce8ca5075/index.m3u8"))
    }
}

