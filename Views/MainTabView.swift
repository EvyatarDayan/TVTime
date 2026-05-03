//
//  MainTabView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1 // Default to Israel tab (index 1)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GlobalView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Global-TV")
                }
                .tag(0)
            
            IsraelView()
                .tabItem {
                    Image(systemName: "flag.fill")
                    Text("Israel-TV")
                }
                .tag(1)
            
            ShowsView()
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Shows")
                }
                .tag(2)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(3)
            
            RadioView()
                .tabItem {
                    Image(systemName: "radio")
                    Text("Radio")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(5)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
