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
    
    var body: some View {
        List {
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
        if let url = URL(string: "https://bridgyai.com/privacy") {
            openURL(url)
        }
    }
    
    private func openTermsOfService() {
        // Замените на реальный URL ваших условий использования
        if let url = URL(string: "https://bridgyai.com/terms") {
            openURL(url)
        }
    }
    
    private func getAppID() -> String {
        // Замените на реальный App ID вашего приложения в App Store
        return "YOUR_APP_ID"
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
