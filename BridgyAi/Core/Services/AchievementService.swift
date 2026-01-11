//
//  AchievementService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

protocol AchievementServiceProtocol {
    func getAllAchievements() -> [Achievement]
    func checkAchievements(user: User, sessions: [LearningSession], sets: [FlashcardSet]) -> [Achievement]
    func saveAchievements(_ achievements: [Achievement]) -> AnyPublisher<Void, Error>
    func loadAchievements() -> AnyPublisher<[Achievement], Error>
}

class AchievementService: AchievementServiceProtocol {
    private let dataService: DataServiceProtocol
    private let userDefaults = UserDefaults.standard
    private let achievementsKey = "user_achievements"
    
    init(dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.dataService = dataService
    }
    
    func getAllAchievements() -> [Achievement] {
        return AchievementType.allCases.map { type in
            Achievement(type: type)
        }
    }
    
    func checkAchievements(user: User, sessions: [LearningSession], sets: [FlashcardSet]) -> [Achievement] {
        var achievements = loadAchievementsFromStorage()
        
        // Проверяем каждое достижение
        for (index, achievement) in achievements.enumerated() {
            if achievement.isUnlocked {
                continue // Уже разблокировано
            }
            
            var progress: Double = 0.0
            var shouldUnlock = false
            
            switch achievement.type {
            case .firstCard:
                progress = user.totalCardsStudied > 0 ? 1.0 : 0.0
                shouldUnlock = user.totalCardsStudied >= 1
                
            case .cards10:
                progress = min(1.0, Double(user.totalCardsStudied) / 10.0)
                shouldUnlock = user.totalCardsStudied >= 10
                
            case .cards50:
                progress = min(1.0, Double(user.totalCardsStudied) / 50.0)
                shouldUnlock = user.totalCardsStudied >= 50
                
            case .cards100:
                progress = min(1.0, Double(user.totalCardsStudied) / 100.0)
                shouldUnlock = user.totalCardsStudied >= 100
                
            case .cards500:
                progress = min(1.0, Double(user.totalCardsStudied) / 500.0)
                shouldUnlock = user.totalCardsStudied >= 500
                
            case .streak3:
                progress = min(1.0, Double(user.streakDays) / 3.0)
                shouldUnlock = user.streakDays >= 3
                
            case .streak7:
                progress = min(1.0, Double(user.streakDays) / 7.0)
                shouldUnlock = user.streakDays >= 7
                
            case .streak30:
                progress = min(1.0, Double(user.streakDays) / 30.0)
                shouldUnlock = user.streakDays >= 30
                
            case .streak100:
                progress = min(1.0, Double(user.streakDays) / 100.0)
                shouldUnlock = user.streakDays >= 100
                
            case .time1hour:
                let hours = user.totalStudyTime / 3600.0
                progress = min(1.0, hours / 1.0)
                shouldUnlock = hours >= 1.0
                
            case .time10hours:
                let hours = user.totalStudyTime / 3600.0
                progress = min(1.0, hours / 10.0)
                shouldUnlock = hours >= 10.0
                
            case .time50hours:
                let hours = user.totalStudyTime / 3600.0
                progress = min(1.0, hours / 50.0)
                shouldUnlock = hours >= 50.0
                
            case .perfectSession:
                // Проверяем последние сессии на идеальную
                let perfectSessions = sessions.filter { session in
                    session.cardsStudied > 0 && session.incorrectAnswers == 0
                }
                progress = perfectSessions.isEmpty ? 0.0 : 1.0
                shouldUnlock = !perfectSessions.isEmpty
                
            case .masterSet:
                // Проверяем, есть ли набор с 100% мастерством
                let masteredSets = sets.filter { $0.masteryLevel >= 1.0 }
                progress = sets.isEmpty ? 0.0 : Double(masteredSets.count) / Double(sets.count)
                shouldUnlock = !masteredSets.isEmpty
                
            case .speedDemon:
                // Проверяем сессии, где прошли 20+ карточек за 5 минут
                let fastSessions = sessions.filter { session in
                    session.cardsStudied >= 20 && session.duration <= 300
                }
                progress = fastSessions.isEmpty ? 0.0 : 1.0
                shouldUnlock = !fastSessions.isEmpty
            }
            
            achievements[index].progress = progress
            if shouldUnlock && achievements[index].unlockedAt == nil {
                achievements[index].unlockedAt = Date()
            }
        }
        
        return achievements
    }
    
    func saveAchievements(_ achievements: [Achievement]) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "AchievementService", code: -1)))
                return
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(achievements)
                self.userDefaults.set(data, forKey: self.achievementsKey)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadAchievements() -> AnyPublisher<[Achievement], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "AchievementService", code: -1)))
                return
            }
            
            let achievements = self.loadAchievementsFromStorage()
            promise(.success(achievements))
        }
        .eraseToAnyPublisher()
    }
    
    private func loadAchievementsFromStorage() -> [Achievement] {
        // Выполняем синхронную операцию быстро, без блокировки
        guard let data = userDefaults.data(forKey: achievementsKey) else {
            return getAllAchievements()
        }
        
        guard let achievements = try? JSONDecoder().decode([Achievement].self, from: data) else {
            return getAllAchievements()
        }
        
        // Убеждаемся, что все типы достижений присутствуют
        let allTypes = Set(AchievementType.allCases)
        let existingTypes = Set(achievements.map { $0.type })
        let missingTypes = allTypes.subtracting(existingTypes)
        
        var result = achievements
        for type in missingTypes {
            result.append(Achievement(type: type))
        }
        
        return result.sorted { $0.type.rawValue < $1.type.rawValue }
    }
}
