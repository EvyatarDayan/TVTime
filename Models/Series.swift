//
//  Series.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-25.
//

import Foundation

struct Series: Identifiable, Codable {
    let id: String
    let name: String
    var imageName: String?
    var backgroundImageName: String?
    var episodes: [Episode]
    
    init(name: String, imageName: String? = nil, backgroundImageName: String? = nil, episodes: [Episode] = []) {
        self.id = UUID().uuidString
        self.name = name
        self.imageName = imageName
        self.backgroundImageName = backgroundImageName
        self.episodes = episodes
    }
}

struct Episode: Identifiable, Codable {
    let id: String
    let episodeNumber: Int
    let name: String
    var streamURL: String?
    var imageName: String?
    var backgroundImageName: String?
    
    init(episodeNumber: Int, name: String, streamURL: String? = nil, imageName: String? = nil, backgroundImageName: String? = nil) {
        self.id = UUID().uuidString
        self.episodeNumber = episodeNumber
        self.name = name
        self.streamURL = streamURL
        self.imageName = imageName
        self.backgroundImageName = backgroundImageName
    }
}

