//
//  FlashcardSessionViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine
import SwiftUI

class FlashcardSessionViewModel: ObservableObject {
    @Published var currentCardIndex: Int = 0
    @Published var isFlipped: Bool = false
    @Published var showAnswer: Bool = false
    @Published var isSessionComplete: Bool = false
    @Published var correctCount: Int = 0
    @Published var incorrectCount: Int = 0
    
    let set: FlashcardSet
    private var cards: [Flashcard] = []
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(set: FlashcardSet, dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.set = set
        self.dataService = dataService
        // Безопасная инициализация - проверяем, что карточки не пустые
        self.cards = set.cards.isEmpty ? [] : set.cards
    }
    
    var currentCard: Flashcard? {
        guard currentCardIndex < cards.count else { return nil }
        return cards[currentCardIndex]
    }
    
    var progress: Double {
        guard !cards.isEmpty else { return 0.0 }
        return Double(currentCardIndex) / Double(cards.count)
    }
    
    var remainingCards: Int {
        max(0, cards.count - currentCardIndex)
    }
    
    func flipCard() {
       
        withAnimation {
            isFlipped.toggle()
        }
    }
    
    func markAsKnown() {
        guard let card = currentCard else { return }
        
        correctCount += 1
        
        // Обновляем прогресс карточки
        dataService.updateMastery(cardId: card.id, isCorrect: true)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        moveToNextCard()
    }
    
    func markAsUnknown() {
        guard let card = currentCard else { return }
        
        incorrectCount += 1
        
        // Обновляем прогресс карточки
        dataService.updateMastery(cardId: card.id, isCorrect: false)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        moveToNextCard()
    }
    
    private func moveToNextCard() {
        currentCardIndex += 1
        
        if currentCardIndex >= cards.count {
            completeSession()
        } else {
            resetCardState()
        }
    }
    
    private func resetCardState() {
        isFlipped = false
        showAnswer = false
    }
    
    private func completeSession() {
        isSessionComplete = true
        
        // Сохраняем сессию
        let session = LearningSession(
            setId: set.id,
            mode: .flashcards,
            endTime: Date(),
            cardsStudied: cards.count,
            correctAnswers: correctCount,
            incorrectAnswers: incorrectCount,
            duration: 0 // В реальности нужно отслеживать время
        )
        
        dataService.saveLearningSession(session)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

