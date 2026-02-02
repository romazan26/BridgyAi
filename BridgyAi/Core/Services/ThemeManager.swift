//
//  ThemeManager.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI
import Combine

/// Варианты темы приложения
enum AppTheme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light:
            return "Светлая"
        case .dark:
            return "Темная"
        case .system:
            return "Как в системе"
        }
    }
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "iphone"
        }
    }
    
    /// Преобразование в ColorScheme для SwiftUI
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil // nil означает системную тему
        }
    }
}

/// Менеджер темы приложения
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            saveTheme()
        }
    }
    
    private let themeKey = "app_theme"
    
    private init() {
        // Загружаем сохраненную тему или используем системную по умолчанию
        if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .system
        }
    }
    
    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
        print("🎨 Тема сохранена: \(currentTheme.displayName)")
    }
    
    /// Получить ColorScheme для применения к приложению
    var preferredColorScheme: ColorScheme? {
        return currentTheme.colorScheme
    }
}
