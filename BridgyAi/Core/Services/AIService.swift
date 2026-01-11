//
//  AIService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

protocol AIServiceProtocol {
    func generateFlashcardSet(topic: String, scenario: WorkScenario, difficulty: DifficultyLevel) -> AnyPublisher<FlashcardSet, Error>
    func generateFeedback(userAnswer: String, correctAnswer: String) -> AnyPublisher<String, Error>
}

class AIService: AIServiceProtocol {
    private let apiKey: String?
    
    init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }
    
    func generateFlashcardSet(topic: String, scenario: WorkScenario, difficulty: DifficultyLevel) -> AnyPublisher<FlashcardSet, Error> {
        // Заглушка для будущей интеграции с OpenAI API
        return Future { promise in
            // В реальной реализации здесь будет запрос к OpenAI API
            let mockSet = FlashcardSet(
                id: UUID().uuidString,
                title: topic,
                description: "AI-generated set for \(scenario.title)",
                workScenario: scenario,
                difficulty: difficulty,
                cards: Flashcard.mockArray,
                author: "AI Tutor",
                isPremium: true,
                averageStudyTime: 20,
                totalTerms: 10,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            )
            promise(.success(mockSet))
        }
        .eraseToAnyPublisher()
    }
    
    func generateFeedback(userAnswer: String, correctAnswer: String) -> AnyPublisher<String, Error> {
        // Заглушка для будущей интеграции
        return Just("Good attempt! Remember: \(correctAnswer)")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


