//
//  ProgressService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

protocol ProgressServiceProtocol {
    func calculateNextReviewDate(cardId: String, isCorrect: Bool, currentLevel: Double) -> Date
    func updateCardProgress(cardId: String, isCorrect: Bool) -> AnyPublisher<Double, Error>
    func getCardMasteryLevel(cardId: String) -> AnyPublisher<Double, Error>
}

class ProgressService: ProgressServiceProtocol {
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    // Алгоритм интервальных повторений (Spaced Repetition)
    func calculateNextReviewDate(cardId: String, isCorrect: Bool, currentLevel: Double) -> Date {
        let calendar = Calendar.current
        var daysToAdd = 1
        
        if isCorrect {
            // Увеличиваем интервал при правильном ответе
            switch currentLevel {
            case 0.0..<0.3:
                daysToAdd = 1
            case 0.3..<0.5:
                daysToAdd = 3
            case 0.5..<0.7:
                daysToAdd = 7
            case 0.7..<0.9:
                daysToAdd = 14
            default:
                daysToAdd = 30
            }
        } else {
            // При неправильном ответе повторяем через день
            daysToAdd = 1
        }
        
        return calendar.date(byAdding: .day, value: daysToAdd, to: Date()) ?? Date()
    }
    
    func updateCardProgress(cardId: String, isCorrect: Bool) -> AnyPublisher<Double, Error> {
        return getCardMasteryLevel(cardId: cardId)
            .map { currentLevel in
                var newLevel = currentLevel
                
                if isCorrect {
                    // Увеличиваем мастерство при правильном ответе
                    newLevel = min(1.0, currentLevel + 0.1)
                } else {
                    // Уменьшаем при неправильном
                    newLevel = max(0.0, currentLevel - 0.2)
                }
                
                return newLevel
            }
            .eraseToAnyPublisher()
    }
    
    func getCardMasteryLevel(cardId: String) -> AnyPublisher<Double, Error> {
        // В реальной реализации здесь будет запрос к хранилищу
        return Just(0.0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


