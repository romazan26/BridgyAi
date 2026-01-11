//
//  FlashcardSet.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

struct FlashcardSet: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let workScenario: WorkScenario
    let difficulty: DifficultyLevel
    let cards: [Flashcard]
    let author: String?
    let isPremium: Bool
    let averageStudyTime: Int // в минутах
    let totalTerms: Int
    let createdAt: Date
    var lastStudied: Date?
    var masteryLevel: Double // 0.0 - 1.0
    var isFavorite: Bool
    
    static let mock = FlashcardSet(
        id: "set_001",
        title: "Weekly Stand-up Meetings",
        description: "Essential phrases for daily stand-up meetings in tech companies",
        workScenario: .meetings,
        difficulty: .beginner,
        cards: Flashcard.mockArray,
        author: "BridgyAI Team",
        isPremium: false,
        averageStudyTime: 15,
        totalTerms: 12,
        createdAt: Date(),
        lastStudied: nil,
        masteryLevel: 0.0,
        isFavorite: false
    )
}


