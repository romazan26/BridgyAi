//
//  HomeViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var userName: String = "User"
    @Published var dailyGoalProgress: Double = 0.0
    @Published var streakDays: Int = 0
    @Published var recommendedSets: [FlashcardSet] = []
    @Published var recentSessions: [LearningSession] = []
    @Published var notificationCount: Int = 0
    @Published var isLoading = false
    
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var hasLoadedData = false
    
    init(dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.dataService = dataService
    }
    
    func loadData() {
        // Предотвращаем множественные одновременные загрузки
        guard !isLoading else { return }
        
        isLoading = true
        
        // Загружаем пользователя
        dataService.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] user in
                    self?.userName = user.name
                    self?.streakDays = user.streakDays
                    self?.calculateDailyProgress(user: user)
                }
            )
            .store(in: &cancellables)
        
        // Загружаем наборы
        dataService.fetchSets()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] sets in
                    self?.recommendedSets = Array(sets.prefix(3))
                }
            )
            .store(in: &cancellables)
        
        // Загружаем сессии
        dataService.fetchTodaySessions()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] sessions in
                    self?.recentSessions = Array(sessions.suffix(5))
                }
            )
            .store(in: &cancellables)
    }
    
    private func calculateDailyProgress(user: User) {
        dataService.fetchTodaySessions()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] sessions in
                    let cardsStudied = sessions.reduce(0) { $0 + $1.cardsStudied }
                    let progress = user.dailyGoal > 0
                        ? min(1.0, Double(cardsStudied) / Double(user.dailyGoal))
                        : 0.0
                    self?.dailyGoalProgress = progress
                }
            )
            .store(in: &cancellables)
    }
    
    func startQuickSession() {
        // Навигация к быстрой сессии
    }
    
    func createNewSet() {
        // Навигация к созданию набора
    }
    
    func practiceWeakSpots() {
        // Навигация к слабым местам
    }
}


