//
//  LearningSession.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

struct LearningSession: Identifiable, Codable {
    let id: String
    let setId: String
    let mode: LearningMode
    let startTime: Date
    var endTime: Date?
    var cardsStudied: Int
    var correctAnswers: Int
    var incorrectAnswers: Int
    var duration: TimeInterval // в секундах
    
    init(
        id: String = UUID().uuidString,
        setId: String,
        mode: LearningMode,
        startTime: Date = Date(),
        endTime: Date? = nil,
        cardsStudied: Int = 0,
        correctAnswers: Int = 0,
        incorrectAnswers: Int = 0,
        duration: TimeInterval = 0
    ) {
        self.id = id
        self.setId = setId
        self.mode = mode
        self.startTime = startTime
        self.endTime = endTime
        self.cardsStudied = cardsStudied
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.duration = duration
    }
    
    static let mock = LearningSession(
        setId: "set_001",
        mode: .flashcards,
        startTime: Date().addingTimeInterval(-3600),
        endTime: Date().addingTimeInterval(-3300),
        cardsStudied: 15,
        correctAnswers: 12,
        incorrectAnswers: 3,
        duration: 300
    )
}

enum LearningMode: String, Codable, CaseIterable, Identifiable {
    case flashcards = "flashcards"
    case write = "write"
    case speak = "speak"
    case test = "test"
    case match = "match"
    case gravity = "gravity"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .flashcards: return "Flashcards"
        case .write: return "Write"
        case .speak: return "Speak"
        case .test: return "Test"
        case .match: return "Match"
        case .gravity: return "Gravity"
        }
    }
    
    var icon: String {
        switch self {
        case .flashcards: return "rectangle.stack"
        case .write: return "pencil"
        case .speak: return "mic"
        case .test: return "checkmark.circle"
        case .match: return "square.grid.2x2"
        case .gravity: return "arrow.down"
        }
    }
}


