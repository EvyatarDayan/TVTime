//
//  ChannelPlayerView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct ChannelPlayerView: View {
    let channel: Channel
    
    var body: some View {
        Group {
            if let streamURL = channel.streamURL, streamURL.isWebEmbed() {
                WebVideoPlayerView(channel: channel)
            } else {
                VideoPlayerView(channel: channel)
            }
        }
    }
}

#Preview {
    NavigationView {
        ChannelPlayerView(channel: Channel(name: "Test Channel", streamURL: "https://d2xg1g9o5vns8m.cloudfront.net/out/v1/0855d703f7d5436fae6a9c7ce8ca5075/index.m3u8"))
    }
}


