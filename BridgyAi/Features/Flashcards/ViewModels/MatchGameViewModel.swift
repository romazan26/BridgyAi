//
//  MatchGameViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

struct MatchTile: Identifiable {
    let id: String
    let content: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
    let type: TileType
    
    enum TileType {
        case front
        case back
    }
}

class MatchGameViewModel: ObservableObject {
    @Published var tiles: [MatchTile] = []
    @Published var selectedTiles: [MatchTile] = []
    @Published var matchesFound: Int = 0
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 120 // 2 минуты
    @Published var isGameOver: Bool = false
    
    let set: FlashcardSet
    private var timer: Timer?
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var totalMatches: Int {
        return max(0, set.cards.count)
    }
    
    init(set: FlashcardSet, dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.set = set
        self.dataService = dataService
        // Проверяем, что набор не пустой
        guard !set.cards.isEmpty else {
            return
        }
    }
    
    func startGame() {
        createTiles()
        startTimer()
    }
    
    private func createTiles() {
        guard !set.cards.isEmpty else {
            tiles = []
            return
        }
        
        var newTiles: [MatchTile] = []
        
        for card in set.cards {
            newTiles.append(MatchTile(
                id: "\(card.id)_front",
                content: card.front,
                type: .front
            ))
            newTiles.append(MatchTile(
                id: "\(card.id)_back",
                content: card.back,
                type: .back
            ))
        }
        
        tiles = newTiles.shuffled()
    }
    
    func selectTile(_ tile: MatchTile) {
        guard !tile.isFlipped && !tile.isMatched && selectedTiles.count < 2 else { return }
        
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles[index].isFlipped = true
            selectedTiles.append(tiles[index])
            
            if selectedTiles.count == 2 {
                checkMatch()
            }
        }
    }
    
    private func checkMatch() {
        let tile1 = selectedTiles[0]
        let tile2 = selectedTiles[1]
        
        // Проверяем, что это пара (front и back одной карточки)
        let card1Id = tile1.id.replacingOccurrences(of: "_front", with: "").replacingOccurrences(of: "_back", with: "")
        let card2Id = tile2.id.replacingOccurrences(of: "_front", with: "").replacingOccurrences(of: "_back", with: "")
        
        if card1Id == card2Id && tile1.type != tile2.type {
            // Match found!
            matchesFound += 1
            score += 10
            
            if let index1 = tiles.firstIndex(where: { $0.id == tile1.id }) {
                tiles[index1].isMatched = true
            }
            if let index2 = tiles.firstIndex(where: { $0.id == tile2.id }) {
                tiles[index2].isMatched = true
            }
            
            selectedTiles.removeAll()
            
            if matchesFound >= totalMatches {
                endGame()
            }
        } else {
            // No match, flip back
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let index1 = self.tiles.firstIndex(where: { $0.id == tile1.id }) {
                    self.tiles[index1].isFlipped = false
                }
                if let index2 = self.tiles.firstIndex(where: { $0.id == tile2.id }) {
                    self.tiles[index2].isFlipped = false
                }
                self.selectedTiles.removeAll()
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        isGameOver = true
        
        let session = LearningSession(
            setId: set.id,
            mode: .match,
            endTime: Date(),
            cardsStudied: matchesFound,
            correctAnswers: matchesFound,
            incorrectAnswers: 0,
            duration: TimeInterval(120 - timeRemaining)
        )
        
        dataService.saveLearningSession(session)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func restartGame() {
        matchesFound = 0
        score = 0
        timeRemaining = 120
        isGameOver = false
        selectedTiles.removeAll()
        startGame()
    }
}

