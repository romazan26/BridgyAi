//
//  Flashcard.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

struct Flashcard: Identifiable, Codable {
    let id: String
    let front: String // Контекст/вопрос на английском
    let back: String // Ответ/перевод/объяснение
    let phonetic: String? // Фонетическая транскрипция
    let example: String? // Пример использования
    let hint: String? // Подсказка
    let audioURL: String? // URL аудио произношения
    let imageURL: String? // URL изображения (опционально)
    let tags: [String]
    
    static let mock = Flashcard(
        id: "card_001",
        front: "How to say you'll finish a task by Friday?",
        back: "I'll have it completed by Friday.",
        phonetic: "aɪl hæv ɪt kəmˈpliːtɪd baɪ ˈfraɪdeɪ",
        example: "For the Q3 report, I'll have it completed by Friday.",
        hint: "Use future perfect for deadlines",
        audioURL: nil,
        imageURL: nil,
        tags: ["deadlines", "meetings", "promises"]
    )
    
    static var mockArray: [Flashcard] {
        Array(repeating: mock, count: 10)
    }
}


