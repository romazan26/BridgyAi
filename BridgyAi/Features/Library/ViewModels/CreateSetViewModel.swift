//
//  CreateSetViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import Foundation
import Combine

class CreateSetViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedScenario: WorkScenario = .meetings
    @Published var selectedDifficulty: DifficultyLevel = .beginner
    @Published var cards: [CardDraft] = [CardDraft()]
    
    private let dataService: DataServiceProtocol = AppDependencies.shared.dataService
    
    var isValid: Bool {
        !title.isEmpty && !description.isEmpty && cards.allSatisfy { !$0.front.isEmpty && !$0.back.isEmpty }
    }
    
    func addCard() {
        cards.append(CardDraft())
    }
    
    func saveSet() {
        let flashcards = cards.map { draft in
            Flashcard(
                id: UUID().uuidString,
                front: draft.front,
                back: draft.back,
                phonetic: nil,
                example: nil,
                hint: nil,
                audioURL: nil,
                imageURL: nil,
                tags: []
            )
        }
        
        let set = FlashcardSet(
            id: UUID().uuidString,
            title: title,
            description: description,
            workScenario: selectedScenario,
            difficulty: selectedDifficulty,
            cards: flashcards,
            author: nil,
            isPremium: false,
            averageStudyTime: flashcards.count * 2,
            totalTerms: flashcards.count,
            createdAt: Date(),
            lastStudied: nil,
            masteryLevel: 0.0,
            isFavorite: false
        )
        
        _ = dataService.saveSet(set)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error saving set: \(error)")
                    }
                },
                receiveValue: { _ in }
            )
    }
}
