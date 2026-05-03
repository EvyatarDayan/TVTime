//
//  SettingsView.swift
//  TVTime
//
//  Created by EVYATAR DAYAN on 2025-10-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingHelp = false
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // App Settings Section
                        SettingsSection(title: "App Settings") {
                            SettingsRow(
                                title: "Dark Mode",
                                trailing: {
                                    Toggle("", isOn: $themeManager.isDarkMode)
                                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                                }
                            )
                        }
                        
                        // Support Section
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                title: "Help & Support",
                                action: { showingHelp = true }
                            )
                        }
                        
                        // Legal Section
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                title: "Terms of Service",
                                action: { showingTerms = true }
                            )
                            
                            SettingsRow(
                                title: "Privacy Policy",
                                action: { showingPrivacy = true }
                            )
                        }
                        
                        // About Section
                        SettingsSection(title: "About") {
                            SettingsRow(
                                title: "About TVTime",
                                action: { showingAbout = true }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .background(themeManager.backgroundPrimary)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(themeManager.colorScheme)
        .onChange(of: themeManager.isDarkMode) { newValue in
            print("SettingsView: Dark mode changed to \(newValue)")
        }
        .sheet(isPresented: $showingHelp) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingTerms) {
            TermsView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    @EnvironmentObject var themeManager: ThemeManager
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(themeManager.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct SettingsRow<Trailing: View>: View {
    let title: String
    let action: (() -> Void)?
    let trailing: Trailing
    
    init(
        title: String,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.action = action
        self.trailing = trailing()
    }
    
    var body: some View {
        if action != nil {
            Button(action: action!) {
                HStack(spacing: 16) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    trailing
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(16)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            HStack(spacing: 16) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                trailing
            }
            .padding(16)
        }
    }
}

// MARK: - Help & Support View
struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title with emoji
//                    HStack {
//                        Text("📞 Help & Support")
//                            .font(.title)
//                            .fontWeight(.bold)
//                    }
//                    .padding(.top, 20)
                    
                    // Welcome message
                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Welcome to the Help & Support!")
//                            .font(.headline)
//                            .fontWeight(.semibold)
                        
                        Text("If you're having trouble watching a channel, loading a stream, or using any feature in the app, try the following steps:")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Troubleshooting steps
                    VStack(alignment: .leading, spacing: 12) {
                        HelpStepItem(
                            icon: "wifi",
                            title: "Check your internet connection",
                            description: "A stable connection is required for smooth streaming."
                        )
                        
                        HelpStepItem(
                            icon: "arrow.clockwise",
                            title: "Restart the app",
                            description: "Sometimes a quick restart fixes most playback issues."
                        )
                        
                        HelpStepItem(
                            icon: "arrow.up.circle",
                            title: "Update the app",
                            description: "Make sure you're using the latest version for best performance."
                        )
                        
                        HelpStepItem(
                            icon: "exclamationmark.triangle",
                            title: "Channel unavailable?",
                            description: "Some streams may change or become temporarily offline. Try again later."
                        )
                    }
                    
                    // Contact section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("If the problem continues or you'd like to share feedback, please contact our support team at abashelariprod@gmail.com — we'll be happy to help!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Email button
                        Button(action: {
                            if let url = URL(string: "mailto:abashelariprod@gmail.com") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("abashelariprod@gmail.com")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 8)
                    
                    // Thank you message
                    Text("Thank you for using TVTime.")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("Help & Support")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HelpStepItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 30, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(answer)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Terms View
struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Service")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last updated: January 1, 2025")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TermsSection(title: "1. Acceptance of Terms", content: "By using TVTime, you agree to be bound by these Terms of Service.")
                        
                        TermsSection(title: "2. Use License", content: "Permission is granted to use TVTime for personal, non-commercial purposes.")
                        
                        TermsSection(title: "3. Disclaimer", content: "The streams provided are for entertainment purposes only. We do not guarantee the availability or quality of any stream.")
                        
                        TermsSection(title: "4. Privacy", content: "Your privacy is important to us. Please review our Privacy Policy for information on how we collect and use your data.")
                    }
                }
                .padding()
            }
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TermsSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Privacy View
struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last updated: January 1, 2025")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TermsSection(title: "Information We Collect", content: "We collect minimal information necessary to provide our service, including your favorite channels preferences.")
                        
                        TermsSection(title: "How We Use Information", content: "We use your information solely to provide and improve our streaming service.")
                        
                        TermsSection(title: "Data Storage", content: "Your favorites are stored locally on your device. We do not transmit personal data to external servers.")
                        
                        TermsSection(title: "Third-Party Services", content: "We may use third-party streaming services. Please review their privacy policies.")
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
//                    Image(systemName: "tv.fill")
//                        .font(.system(size: 60))
//                        .foregroundColor(.blue)
                    
//                    Text("TVTime")
//                        .font(.title)
//                        .fontWeight(.bold)
//                    
//                    Text("Version 1.0.0")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("TVTime is a global streaming platform designed to provide users with convenient access to publicly available live television and video content.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Our mission is to deliver a seamless viewing experience by organizing verified, freely accessible streams from trusted sources around the world.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("We believe in open access to information and entertainment, offering a curated collection of news, educational, and cultural programming — all without subscription fees or intrusive advertising.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("TVTime is committed to transparency, reliability, and continuous improvement to ensure a high-quality experience for our users.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("© 2025 TVTime. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager.shared)
}
