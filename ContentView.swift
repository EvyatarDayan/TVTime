//
//  ContentView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            if showMainApp {
                MainTabView()
                    .transition(.opacity)
            } else {
                LogoView {
                    withAnimation(.easeIn(duration: 0.5)) {
                        showMainApp = true
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
