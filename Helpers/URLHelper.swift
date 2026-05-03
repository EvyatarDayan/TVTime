//
//  URLHelper.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import Foundation

extension String {
    /// Check if a URL is a web embed (YouTube, etc.) that requires a WebView
    func isWebEmbed() -> Bool {
        let webEmbedPatterns = [
            "youtube.com/embed",
            "youtube-nocookie.com/embed",
            "youtube.com/watch",
            "youtu.be/",
            "vimeo.com/",
            "dailymotion.com/embed",
            "facebook.com/",
            "twitter.com/",
            "instagram.com/"
        ]
        
        let lowercased = self.lowercased()
        return webEmbedPatterns.contains { lowercased.contains($0) }
    }
}



