//
//  ThemeManager.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            print("Dark mode changed to: \(isDarkMode)")
        }
    }
    
    private init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        print("ThemeManager initialized with dark mode: \(isDarkMode)")
    }
    
    var colorScheme: ColorScheme {
        return isDarkMode ? .dark : .light
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
    
    // Theme-aware colors
    var cardBackground: Color {
        return isDarkMode ? Color(UIColor.systemGray6) : Color.white
    }
    
    var backgroundPrimary: Color {
        return isDarkMode ? Color.black : Color(UIColor.systemGray6)
    }
}

// MARK: - Color Extensions for Dark Mode
extension Color {
    static let cardBackground = Color(UIColor.systemBackground)
    static let cardBackgroundSecondary = Color(UIColor.secondarySystemBackground)
    static let textPrimary = Color(UIColor.label)
    static let textSecondary = Color(UIColor.secondaryLabel)
    static let backgroundPrimary = Color(UIColor.systemGroupedBackground)
    static let backgroundSecondary = Color(UIColor.secondarySystemGroupedBackground)
    
}
