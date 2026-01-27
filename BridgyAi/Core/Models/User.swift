//
//  User.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String?
    var avatarImageData: Data? // Данные изображения профиля
    var level: DifficultyLevel
    var dailyGoal: Int // количество карточек в день
    var streakDays: Int
    var totalCardsStudied: Int
    var totalStudyTime: TimeInterval // в секундах
    var isPremium: Bool
    var createdAt: Date
    var lastActiveDate: Date
    
    init(
        id: String = UUID().uuidString,
        name: String,
        email: String? = nil,
        avatarImageData: Data? = nil,
        level: DifficultyLevel = .beginner,
        dailyGoal: Int = 20,
        streakDays: Int = 0,
        totalCardsStudied: Int = 0,
        totalStudyTime: TimeInterval = 0,
        isPremium: Bool = false,
        createdAt: Date = Date(),
        lastActiveDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarImageData = avatarImageData
        self.level = level
        self.dailyGoal = dailyGoal
        self.streakDays = streakDays
        self.totalCardsStudied = totalCardsStudied
        self.totalStudyTime = totalStudyTime
        self.isPremium = isPremium
        self.createdAt = createdAt
        self.lastActiveDate = lastActiveDate
    }
}


