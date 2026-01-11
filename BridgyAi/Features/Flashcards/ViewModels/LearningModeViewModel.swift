//
//  LearningModeViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class LearningModeViewModel: ObservableObject {
    @Published var currentCardIndex: Int = 0
    @Published var userInput: String = ""
    @Published var lastResult: AnswerResult?
    @Published var isSessionComplete: Bool = false
    @Published var correctCount: Int = 0
    @Published var incorrectCount: Int = 0
    
    let set: FlashcardSet
    let mode: LearningMode
    private var cards: [Flashcard] = []
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(set: FlashcardSet, mode: LearningMode, dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.set = set
        self.mode = mode
        self.dataService = dataService
        // Безопасная инициализация - проверяем, что карточки не пустые
        self.cards = set.cards.isEmpty ? [] : set.cards.shuffled()
    }
    
    var currentCard: Flashcard? {
        guard currentCardIndex < cards.count else { return nil }
        return cards[currentCardIndex]
    }
    
    var progress: Double {
        guard !cards.isEmpty else { return 0.0 }
        return Double(currentCardIndex) / Double(cards.count)
    }
    
    func checkAnswer(_ answer: String) {
        guard let card = currentCard else { return }
        
        let isCorrect = answer.fuzzyMatch(card.back)
        lastResult = AnswerResult(
            isCorrect: isCorrect,
            userAnswer: answer,
            correctAnswer: card.back
        )
        
        if isCorrect {
            correctCount += 1
            dataService.updateMastery(cardId: card.id, isCorrect: true)
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &cancellables)
        } else {
            incorrectCount += 1
            dataService.updateMastery(cardId: card.id, isCorrect: false)
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &cancellables)
        }
    }
    
    func nextCard() {
        currentCardIndex += 1
        userInput = ""
        lastResult = nil
        
        if currentCardIndex >= cards.count {
            completeSession()
        }
    }
    
    private func completeSession() {
        isSessionComplete = true
        
        let session = LearningSession(
            setId: set.id,
            mode: mode,
            endTime: Date(),
            cardsStudied: cards.count,
            correctAnswers: correctCount,
            incorrectAnswers: incorrectCount,
            duration: 0
        )
        
        dataService.saveLearningSession(session)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

struct AnswerResult {
    let isCorrect: Bool
    let userAnswer: String
    let correctAnswer: String
}

