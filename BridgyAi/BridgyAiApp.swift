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
    
    var body: some Scene {
        WindowGroup {
            if appViewModel.isOnboardingCompleted {
                MainTabView()
            } else {
                OnboardingView(appViewModel: appViewModel)
            }
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
