//
//  CustomVideoPlayer.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Disable all full-screen behaviors
        playerViewController.showsPlaybackControls = true
        playerViewController.allowsPictureInPicturePlayback = false
        playerViewController.videoGravity = .resizeAspect
        
        // This is the key - disable the native full-screen button
        playerViewController.showsPlaybackControls = true
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update if needed
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        // Clean up when dismissed
        uiViewController.player?.pause()
    }
}

// Extension to hide the full-screen button
extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove the full-screen button from controls
        if let fullScreenButton = findFullScreenButton() {
            fullScreenButton.isHidden = true
        }
    }
    
    private func findFullScreenButton() -> UIButton? {
        return findButton(in: view, withTitle: nil, withImageName: "fullscreen")
    }
    
    private func findButton(in view: UIView, withTitle title: String?, withImageName imageName: String?) -> UIButton? {
        if let button = view as? UIButton {
            if let title = title, button.title(for: .normal) == title {
                return button
            }
            if let imageName = imageName, button.image(for: .normal)?.accessibilityIdentifier == imageName {
                return button
            }
            // Check for fullscreen icon by looking at the button's image
            if let image = button.image(for: .normal),
               let cgImage = image.cgImage {
                // This is a simplified check - you might need to adjust based on the actual icon
                return button
            }
        }
        
        for subview in view.subviews {
            if let button = findButton(in: subview, withTitle: title, withImageName: imageName) {
                return button
            }
        }
        
        return nil
    }
}


