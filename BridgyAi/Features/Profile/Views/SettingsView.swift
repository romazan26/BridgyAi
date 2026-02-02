//
//  SettingsView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        List {
            // Секция выбора темы
            Section {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(AppConstants.Colors.bridgyPrimary)
                            .font(.title3)
                        Text("Оформление")
                            .font(AppConstants.Fonts.headline)
                    }
                    
                    HStack(spacing: AppConstants.Spacing.small) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            ThemeOptionButton(
                                theme: theme,
                                isSelected: themeManager.currentTheme == theme,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        themeManager.currentTheme = theme
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.vertical, AppConstants.Spacing.small)
            } header: {
                Text("Тема")
            }
            
            Section("О приложении") {
                Button(action: {
                    rateApp()
                }) {
                    SettingsRow(title: "Оценить приложение", icon: "star.fill")
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    openPrivacyPolicy()
                }) {
                    SettingsRow(title: "Политика конфиденциальности", icon: "lock.shield.fill")
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    openTermsOfService()
                }) {
                    SettingsRow(title: "Условия использования", icon: "doc.text.fill")
                        .foregroundColor(.primary)
                }
            }
            
            Section("Версия") {
                HStack {
                    Text("Версия")
                        .font(AppConstants.Fonts.body)
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Настройки")
        .listStyle(.insetGrouped)
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openPrivacyPolicy() {
        // Замените на реальный URL вашей политики конфиденциальности
        if let url = URL(string: "https://www.termsfeed.com/live/d8406493-2b5c-4562-b1f1-b3fb1188cbfd") {
            openURL(url)
        }
    }
    
    private func openTermsOfService() {
        // Замените на реальный URL ваших условий использования
        if let url = URL(string: "https://www.termsfeed.com/live/a6606792-a441-409a-ad65-2e23fc1fde51") {
            openURL(url)
        }
    }
    
    private func getAppID() -> String {
        // Замените на реальный App ID вашего приложения в App Store
        return "YOUR_APP_ID"
    }
}

/// Кнопка выбора темы
struct ThemeOptionButton: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppConstants.Spacing.small) {
                // Иконка темы
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                                ? LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppConstants.Colors.bridgyPrimary,
                                        AppConstants.Colors.bridgySecondary
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(.systemGray5),
                                        Color(.systemGray6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: theme.icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .white : .secondary)
                }
                
                // Название темы
                Text(theme.displayName)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(isSelected ? AppConstants.Colors.bridgyPrimary : .secondary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppConstants.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .fill(isSelected ? AppConstants.Colors.bridgyPrimary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .stroke(
                        isSelected ? AppConstants.Colors.bridgyPrimary : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
