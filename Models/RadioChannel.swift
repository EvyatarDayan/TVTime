//
//  RadioChannel.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import Foundation

struct RadioChannel: Identifiable, Codable {
    let id: String
    let name: String
    var streamURL: String?
    var imageName: String?
    var backgroundImageName: String? // Background image for favorites view
    var isFavorite: Bool = false
    
    init(name: String, streamURL: String? = nil, imageName: String? = nil, backgroundImageName: String? = nil, isFavorite: Bool = false) {
        self.id = name // Use name as ID for consistent identification
        self.name = name
        self.streamURL = streamURL
        self.imageName = imageName
        self.backgroundImageName = backgroundImageName
        self.isFavorite = isFavorite
    }
}
