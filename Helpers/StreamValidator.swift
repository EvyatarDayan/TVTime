//
//  StreamValidator.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import Foundation
import AVFoundation

class StreamValidator {
    static let shared = StreamValidator()
    
    private var cache: [String: Bool] = [:]
    
    private init() {}
    
    /// Check if a stream URL is accessible and valid
    func validateStream(urlString: String, completion: @escaping (Bool) -> Void) {
        // Check cache first
        if let cachedResult = cache[urlString] {
            completion(cachedResult)
            return
        }
        
        guard let url = URL(string: urlString) else {
            cache[urlString] = false
            completion(false)
            return
        }
        
        // Check if it's a YouTube embed or similar web embed
        // These are valid but need a web player instead of AVPlayer
        if isWebEmbed(urlString: urlString) {
            cache[urlString] = true
            completion(true)
            return
        }
        
        // For direct streams, use a simple HEAD request to check if the URL is accessible
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5.0
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                let isValid: Bool
                
                if let error = error {
                    // Network error or timeout
                    isValid = false
                } else if let httpResponse = response as? HTTPURLResponse {
                    // Check if the response status code indicates success
                    isValid = (200...299).contains(httpResponse.statusCode)
                } else {
                    // Unknown response type
                    isValid = false
                }
                
                self.cache[urlString] = isValid
                completion(isValid)
            }
        }
        
        task.resume()
    }
    
    /// Check if a URL is a web embed (YouTube, etc.) rather than a direct stream
    private func isWebEmbed(urlString: String) -> Bool {
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
        
        let lowercased = urlString.lowercased()
        return webEmbedPatterns.contains { lowercased.contains($0) }
    }
    
    /// Clear the validation cache
    func clearCache() {
        cache.removeAll()
    }
}

