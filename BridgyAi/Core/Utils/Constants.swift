//
//  Constants.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import SwiftUI

enum AppConstants {
    // Цвета
    enum Colors {
        static let bridgyPrimary = Color(hex: "#2563EB")
        static let bridgySecondary = Color(hex: "#EC4899")
        static let bridgyBackground = Color(hex: "#F8FAFC")
        static let bridgyCard = Color(hex: "#FFFFFF")
        static let bridgyText = Color(hex: "#1E293B")
        static let bridgySuccess = Color(hex: "#10B981")
        static let bridgyError = Color(hex: "#EF4444")
        static let bridgyWarning = Color(hex: "#F59E0B")
    }
    
    // Шрифты
    enum Fonts {
        static let title = Font.system(.title, design: .rounded, weight: .bold)
        static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }
    
    // Размеры
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
    
    // Радиусы скругления
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    // Тени
    enum Shadows {
        static let small = Color.black.opacity(0.05)
        static let medium = Color.black.opacity(0.1)
        static let large = Color.black.opacity(0.15)
    }
    
    // Идентификаторы специальных наборов
    enum SpecialSets {
        static let myWordsSetId = "my_words_set"
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


