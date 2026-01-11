//
//  ProfileView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.large) {
                    // Профиль пользователя
                    CardView {
                        VStack(spacing: AppConstants.Spacing.medium) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppConstants.Colors.bridgyPrimary)
                            
                            Text(viewModel.userName)
                                .font(AppConstants.Fonts.headline)
                            
                            BadgeView(text: viewModel.userLevel.rawValue, color: Color(viewModel.userLevel.color))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Настройки
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Settings")
                            .font(AppConstants.Fonts.headline)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: SettingsView()) {
                            SettingsRow(title: "Settings", icon: "gearshape.fill")
                        }
                        
                        NavigationLink(destination: SubscriptionView()) {
                            SettingsRow(title: "Subscription", icon: "crown.fill", showBadge: !viewModel.isPremium)
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            SettingsRow(title: "Notifications", icon: "bell.fill")
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .background(AppConstants.Colors.bridgyBackground)
            .onAppear {
                viewModel.loadUser()
            }
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    var showBadge: Bool = false
    
    var body: some View {
        CardView {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    .frame(width: 30)
                
                Text(title)
                    .font(AppConstants.Fonts.body)
                
                Spacer()
                
                if showBadge {
                    BadgeView(text: "Premium", color: AppConstants.Colors.bridgySecondary)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .navigationTitle("Settings")
    }
}

struct SubscriptionView: View {
    var body: some View {
        Text("Subscription")
            .navigationTitle("Subscription")
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("Notifications")
            .navigationTitle("Notifications")
    }
}

#Preview {
    ProfileView()
}


