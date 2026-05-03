//
//  WebVideoPlayerView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI
import WebKit

struct WebVideoPlayerView: View {
    let channel: Channel
    @State private var showFullScreenPlayer = false
    @StateObject private var favoritesManager = FavoritesManager.shared
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
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
                    
                    // Web video player
                    WebVideoPlayer(url: url)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
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
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
        }
        .fullScreenCover(isPresented: $showFullScreenPlayer) {
            if let urlString = channel.streamURL,
               let url = URL(string: urlString) {
                FullScreenWebPlayerView(url: url, isPresented: $showFullScreenPlayer)
            }
        }
        .onChange(of: showFullScreenPlayer) { isPresented in
            if !isPresented {
                AppDelegate.orientationLock = .portrait
            }
        }
    }
}

struct WebVideoPlayer: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let modifiedURL = addAutoplayToYouTubeURL(url)
        let request = URLRequest(url: modifiedURL)
        webView.load(request)
    }
    
    private func addAutoplayToYouTubeURL(_ url: URL) -> URL {
        let urlString = url.absoluteString
        
        // Check if it's a YouTube URL
        if urlString.contains("youtube.com") || urlString.contains("youtu.be") {
            var modifiedURLString = urlString
            
            // Convert youtu.be/watch?v= to embed format
            if urlString.contains("youtu.be/") {
                let videoID = urlString.components(separatedBy: "youtu.be/").last?.components(separatedBy: "?").first
                if let videoID = videoID {
                    modifiedURLString = "https://www.youtube.com/embed/\(videoID)"
                }
            } else if urlString.contains("youtube.com/watch?v=") {
                let videoID = urlString.components(separatedBy: "v=").last?.components(separatedBy: "&").first
                if let videoID = videoID {
                    modifiedURLString = "https://www.youtube.com/embed/\(videoID)"
                }
            }
            
            // Add autoplay parameters if not already present
            if !modifiedURLString.contains("autoplay=") {
                let separator = modifiedURLString.contains("?") ? "&" : "?"
                modifiedURLString += "\(separator)autoplay=1&mute=0&enablejsapi=1&showinfo=0&controls=1&rel=0"
            }
            
            return URL(string: modifiedURLString) ?? url
        }
        
        return url
    }
}

struct FullScreenWebPlayerView: View {
    let url: URL
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            WebVideoPlayer(url: url)
                .ignoresSafeArea()
            
            // Custom close button overlay
            VStack {
                HStack {
                    Button(action: {
                        AppDelegate.orientationLock = .portrait
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .onAppear {
            AppDelegate.orientationLock = .landscape
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        WebVideoPlayerView(channel: Channel(name: "SKY NEWS", streamURL: "https://www.youtube.com/watch?v=9Auq9mYxFEE"))
            .environmentObject(ThemeManager.shared)
    }
}

