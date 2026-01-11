//
//  Achievement.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import SwiftUI

enum AchievementType: String, Codable, CaseIterable {
    case firstCard = "first_card"
    case cards10 = "cards_10"
    case cards50 = "cards_50"
    case cards100 = "cards_100"
    case cards500 = "cards_500"
    case streak3 = "streak_3"
    case streak7 = "streak_7"
    case streak30 = "streak_30"
    case streak100 = "streak_100"
    case time1hour = "time_1hour"
    case time10hours = "time_10hours"
    case time50hours = "time_50hours"
    case perfectSession = "perfect_session"
    case masterSet = "master_set"
    case speedDemon = "speed_demon"
    
    var title: String {
        switch self {
        case .firstCard: return "Первая карточка"
        case .cards10: return "Новичок"
        case .cards50: return "Ученик"
        case .cards100: return "Опытный"
        case .cards500: return "Мастер"
        case .streak3: return "Три дня подряд"
        case .streak7: return "Неделя силы"
        case .streak30: return "Месяц практики"
        case .streak100: return "Легенда"
        case .time1hour: return "Час обучения"
        case .time10hours: return "10 часов"
        case .time50hours: return "50 часов"
        case .perfectSession: return "Идеальная сессия"
        case .masterSet: return "Мастер набора"
        case .speedDemon: return "Скорость"
        }
    }
    
    var description: String {
        switch self {
        case .firstCard: return "Изучите первую карточку"
        case .cards10: return "Изучите 10 карточек"
        case .cards50: return "Изучите 50 карточек"
        case .cards100: return "Изучите 100 карточек"
        case .cards500: return "Изучите 500 карточек"
        case .streak3: return "Занимайтесь 3 дня подряд"
        case .streak7: return "Занимайтесь неделю подряд"
        case .streak30: return "Занимайтесь месяц подряд"
        case .streak100: return "Занимайтесь 100 дней подряд"
        case .time1hour: return "Потратьте 1 час на обучение"
        case .time10hours: return "Потратьте 10 часов на обучение"
        case .time50hours: return "Потратьте 50 часов на обучение"
        case .perfectSession: return "Пройдите сессию без ошибок"
        case .masterSet: return "Достигните 100% мастерства в наборе"
        case .speedDemon: return "Пройдите 20 карточек за 5 минут"
        }
    }
    
    var icon: String {
        switch self {
        case .firstCard: return "star.fill"
        case .cards10: return "number.circle.fill"
        case .cards50: return "number.circle.fill"
        case .cards100: return "number.circle.fill"
        case .cards500: return "number.circle.fill"
        case .streak3: return "flame.fill"
        case .streak7: return "flame.fill"
        case .streak30: return "flame.fill"
        case .streak100: return "flame.fill"
        case .time1hour: return "clock.fill"
        case .time10hours: return "clock.fill"
        case .time50hours: return "clock.fill"
        case .perfectSession: return "checkmark.seal.fill"
        case .masterSet: return "crown.fill"
        case .speedDemon: return "bolt.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .firstCard: return AppConstants.Colors.bridgyWarning
        case .cards10, .cards50, .cards100, .cards500: return AppConstants.Colors.bridgyPrimary
        case .streak3, .streak7, .streak30, .streak100: return AppConstants.Colors.bridgyError
        case .time1hour, .time10hours, .time50hours: return AppConstants.Colors.bridgySuccess
        case .perfectSession: return AppConstants.Colors.bridgySecondary
        case .masterSet: return AppConstants.Colors.bridgyWarning
        case .speedDemon: return AppConstants.Colors.bridgyPrimary
        }
    }
    
    var rarity: AchievementRarity {
        switch self {
        case .firstCard, .cards10, .streak3: return .common
        case .cards50, .streak7, .time1hour: return .uncommon
        case .cards100, .streak30, .time10hours, .perfectSession: return .rare
        case .cards500, .streak100, .time50hours, .masterSet: return .epic
        case .speedDemon: return .legendary
        }
    }
}

enum AchievementRarity: String, Codable {
    case common = "common"
    case uncommon = "uncommon"
    case rare = "rare"
    case epic = "epic"
    case legendary = "legendary"
    
    var gradientColors: [Color] {
        switch self {
        case .common: return [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]
        case .uncommon: return [Color.green.opacity(0.3), Color.green.opacity(0.1)]
        case .rare: return [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]
        case .epic: return [Color.purple.opacity(0.3), Color.purple.opacity(0.1)]
        case .legendary: return [Color.orange.opacity(0.4), Color.yellow.opacity(0.2)]
        }
    }
}

struct Achievement: Identifiable, Codable {
    let id: String
    let type: AchievementType
    var unlockedAt: Date?
    var progress: Double // 0.0 - 1.0
    
    var isUnlocked: Bool {
        unlockedAt != nil
    }
    
    init(
        id: String = UUID().uuidString,
        type: AchievementType,
        unlockedAt: Date? = nil,
        progress: Double = 0.0
    ) {
        self.id = id
        self.type = type
        self.unlockedAt = unlockedAt
        self.progress = progress
    }
}
