//
//  BridgyAiApp.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

@main
struct BridgyAiApp: App {
    @StateObject private var appViewModel: AppViewModel = {
        // Безопасная инициализация с обработкой ошибок
        return AppViewModel()
    }()
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appViewModel.isOnboardingCompleted {
                    MainTabView()
                } else {
                    OnboardingView(appViewModel: appViewModel)
                }
            }
            .preferredColorScheme(themeManager.preferredColorScheme)
            .environmentObject(themeManager)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
            
            LibraryView()
                .tabItem {
                    Label("Библиотека", systemImage: "book.fill")
                }
            
            ProgressView()
                .tabItem {
                    Label("Прогресс", systemImage: "chart.bar.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
        }
        .accentColor(AppConstants.Colors.bridgyPrimary)
    }
}
