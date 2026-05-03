//
//  FullScreenVideoPlayer.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI
import AVKit

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let url: URL
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Configure for full screen
        playerViewController.showsPlaybackControls = true
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.videoGravity = .resizeAspect
        
        // Force landscape orientation
        AppDelegate.orientationLock = .landscape
        
        // Start playing
        player.play()
        
        // Force rotation to landscape
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            }
        }
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update if needed
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        // Clean up when dismissed
        uiViewController.player?.pause()
        
        // Force back to portrait
        AppDelegate.orientationLock = .portrait
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            }
        }
    }
}

class Coordinator: NSObject {
    var parent: FullScreenVideoPlayer
    
    init(parent: FullScreenVideoPlayer) {
        self.parent = parent
    }
}

struct FullScreenVideoPlayerView: View {
    let url: URL
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            FullScreenVideoPlayer(url: url, isPresented: $isPresented)
                .ignoresSafeArea(.all)
            
            // Custom close button overlay
            VStack {
                HStack {
                    Button(action: {
                        // Force back to portrait before dismissing
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
    }
}
