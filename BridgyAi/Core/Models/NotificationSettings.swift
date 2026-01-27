//
//  NotificationSettings.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import Foundation

enum MotivationType: String, Codable, CaseIterable {
    case encouraging = "encouraging"
    case friendly = "friendly"
    case strict = "strict"
    case playful = "playful"
    
    var title: String {
        switch self {
        case .encouraging:
            return "Поддерживающий"
        case .friendly:
            return "Дружелюбный"
        case .strict:
            return "Строгий"
        case .playful:
            return "Игривый"
        }
    }
    
    var description: String {
        switch self {
        case .encouraging:
            return "Мотивирующие сообщения для поддержки"
        case .friendly:
            return "Дружелюбные и теплые напоминания"
        case .strict:
            return "Строгие и прямые напоминания"
        case .playful:
            return "Веселые и легкие напоминания"
        }
    }
}

struct NotificationSettings: Codable {
    var isEnabled: Bool
    var remindersPerDay: Int // Сколько раз в день напоминать
    var motivationType: MotivationType
    
    static let `default` = NotificationSettings(
        isEnabled: true,
        remindersPerDay: 3,
        motivationType: .encouraging
    )
}
