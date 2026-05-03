//
//  FavoritesManager.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteChannels: [Channel] = []
    @Published var favoriteRadioChannels: [RadioChannel] = []
    
    private let channelsKey = "favoriteChannels"
    private let radioChannelsKey = "favoriteRadioChannels"
    
    private init() {
        loadFavorites()
    }
    
    // MARK: - TV Channels
    func toggleChannelFavorite(_ channel: Channel) {
        if let index = favoriteChannels.firstIndex(where: { $0.id == channel.id }) {
            favoriteChannels.remove(at: index)
        } else {
            var updatedChannel = channel
            updatedChannel.isFavorite = true
            favoriteChannels.append(updatedChannel)
        }
        saveFavorites()
    }
    
    func updateChannelData(_ channel: Channel) {
        // Update the channel data if it's already a favorite
        if let index = favoriteChannels.firstIndex(where: { $0.id == channel.id }) {
            var updatedChannel = channel
            updatedChannel.isFavorite = true
            favoriteChannels[index] = updatedChannel
            saveFavorites()
        }
    }
    
    func isChannelFavorite(_ channel: Channel) -> Bool {
        return favoriteChannels.contains { $0.id == channel.id }
    }
    
    // MARK: - Radio Channels
    func toggleRadioChannelFavorite(_ channel: RadioChannel) {
        if let index = favoriteRadioChannels.firstIndex(where: { $0.id == channel.id }) {
            favoriteRadioChannels.remove(at: index)
        } else {
            var updatedChannel = channel
            updatedChannel.isFavorite = true
            favoriteRadioChannels.append(updatedChannel)
        }
        saveFavorites()
    }
    
    func updateRadioChannelData(_ channel: RadioChannel) {
        // Update the channel data if it's already a favorite
        if let index = favoriteRadioChannels.firstIndex(where: { $0.id == channel.id }) {
            var updatedChannel = channel
            updatedChannel.isFavorite = true
            favoriteRadioChannels[index] = updatedChannel
            saveFavorites()
        }
    }
    
    func isRadioChannelFavorite(_ channel: RadioChannel) -> Bool {
        return favoriteRadioChannels.contains { $0.id == channel.id }
    }
    
    // MARK: - Persistence
    private func saveFavorites() {
        if let channelsData = try? JSONEncoder().encode(favoriteChannels) {
            UserDefaults.standard.set(channelsData, forKey: channelsKey)
        }
        if let radioChannelsData = try? JSONEncoder().encode(favoriteRadioChannels) {
            UserDefaults.standard.set(radioChannelsData, forKey: radioChannelsKey)
        }
    }
    
    private func loadFavorites() {
        if let channelsData = UserDefaults.standard.data(forKey: channelsKey),
           let channels = try? JSONDecoder().decode([Channel].self, from: channelsData) {
            favoriteChannels = channels
        }
        if let radioChannelsData = UserDefaults.standard.data(forKey: radioChannelsKey),
           let radioChannels = try? JSONDecoder().decode([RadioChannel].self, from: radioChannelsData) {
            favoriteRadioChannels = radioChannels
        }
    }
}
