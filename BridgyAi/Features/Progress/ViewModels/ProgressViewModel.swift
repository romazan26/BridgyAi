//
//  ProgressViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class ProgressViewModel: ObservableObject {
    @Published var overallProgress: Double = 0.0
    @Published var totalCardsStudied: Int = 0
    @Published var totalStudyTimeMinutes: Int = 0
    @Published var streakDays: Int = 0
    @Published var achievements: [Achievement] = []
    @Published var isLoading = false
    
    private let dataService: DataServiceProtocol
    private let achievementService: AchievementServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var hasLoadedData = false
    
    init(
        dataService: DataServiceProtocol = AppDependencies.shared.dataService,
        achievementService: AchievementServiceProtocol = AppDependencies.shared.achievementService
    ) {
        self.dataService = dataService
        self.achievementService = achievementService
    }
    
    func loadData() {
        // Предотвращаем множественные одновременные загрузки
        guard !isLoading && !hasLoadedData else { return }
        
        isLoading = true
        
        // Сначала загружаем сохраненные достижения для быстрого отображения
        if achievements.isEmpty {
            achievementService.loadAchievements()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] achievements in
                        self?.achievements = achievements
                    }
                )
                .store(in: &cancellables)
        }
        
        // Загружаем общий прогресс
        dataService.getOverallProgress()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] progress in
                    self?.overallProgress = progress
                }
            )
            .store(in: &cancellables)
        
        // Загружаем пользователя
        dataService.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in },
                receiveValue: { [weak self] user in
                    guard let self = self else { return }
                    self.totalCardsStudied = user.totalCardsStudied
                    self.totalStudyTimeMinutes = Int(user.totalStudyTime / 60)
                    self.streakDays = user.streakDays
                    
                    // Загружаем сессии и наборы параллельно
                    Publishers.Zip(
                        self.dataService.fetchTodaySessions(),
                        self.dataService.fetchSets()
                    )
                    .receive(on: DispatchQueue.main)
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            if case .failure = completion {
                                self?.isLoading = false
                            }
                        },
                        receiveValue: { [weak self] sessions, sets in
                            guard let self = self else { return }
                            
                            // Проверяем достижения в фоне
                            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                                guard let self = self else { return }
                                
                                let updatedAchievements = self.achievementService.checkAchievements(
                                    user: user,
                                    sessions: sessions,
                                    sets: sets
                                )
                                
                                // Сохраняем и обновляем на главном потоке
                                self.achievementService.saveAchievements(updatedAchievements)
                                    .receive(on: DispatchQueue.main)
                                    .sink(
                                        receiveCompletion: { _ in },
                                        receiveValue: { [weak self] _ in
                                            self?.achievements = updatedAchievements
                                            self?.isLoading = false
                                            self?.hasLoadedData = true
                                        }
                                    )
                                    .store(in: &self.cancellables)
                            }
                        }
                    )
                    .store(in: &self.cancellables)
                }
            )
            .store(in: &cancellables)
    }
    
    
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    var unlockedCount: Int {
        unlockedAchievements.count
    }
    
    var totalCount: Int {
        achievements.count
    }
}


