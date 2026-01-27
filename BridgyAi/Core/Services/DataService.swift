//
//  DataService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    // Наборы
    func fetchSets() -> AnyPublisher<[FlashcardSet], Error>
    func fetchSet(by id: String) -> AnyPublisher<FlashcardSet, Error>
    func saveSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error>
    func deleteSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error>
    func toggleFavorite(setId: String) -> AnyPublisher<Bool, Error>
    
    // Мои слова
    func getMyWordsSet() -> AnyPublisher<FlashcardSet, Error>
    func addWordToMyWords(_ card: Flashcard) -> AnyPublisher<Void, Error>
    func removeWordFromMyWords(cardId: String) -> AnyPublisher<Void, Error>
    
    // Сессии обучения
    func saveLearningSession(_ session: LearningSession) -> AnyPublisher<Void, Error>
    func fetchTodaySessions() -> AnyPublisher<[LearningSession], Error>
    
    // Прогресс
    func updateMastery(cardId: String, isCorrect: Bool) -> AnyPublisher<Double, Error>
    func getOverallProgress() -> AnyPublisher<Double, Error>
    
    // Пользователь
    func getCurrentUser() -> AnyPublisher<User, Error>
    func updateUser(_ user: User) -> AnyPublisher<Void, Error>
}

protocol LocalStoreProtocol {
    func fetchSets() -> AnyPublisher<[FlashcardSet], Error>
    func saveSets(_ sets: [FlashcardSet]) -> AnyPublisher<Void, Error>
    func saveSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error>
    func deleteSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error>
    func fetchSessions() -> AnyPublisher<[LearningSession], Error>
    func saveSession(_ session: LearningSession) -> AnyPublisher<Void, Error>
    func getUser() -> AnyPublisher<User?, Error>
    func saveUser(_ user: User) -> AnyPublisher<Void, Error>
}

protocol MockDataLoaderProtocol {
    func loadSets() -> AnyPublisher<[FlashcardSet], Error>
}

class DataService: DataServiceProtocol {
    private let localStore: LocalStoreProtocol
    private let mockDataLoader: MockDataLoaderProtocol
    
    init(
        localStore: LocalStoreProtocol = UserDefaultsStore(),
        mockDataLoader: MockDataLoaderProtocol = MockDataLoader()
    ) {
        self.localStore = localStore
        self.mockDataLoader = mockDataLoader
    }
    
    func fetchSets() -> AnyPublisher<[FlashcardSet], Error> {
        return localStore.fetchSets()
            .flatMap { sets -> AnyPublisher<[FlashcardSet], Error> in
                // Если наборов нет, загружаем предустановленные
                if sets.isEmpty {
                    let defaultSets = DefaultSetsProvider.getDefaultSets()
                    return self.localStore.saveSets(defaultSets)
                        .map { defaultSets }
                        .eraseToAnyPublisher()
                }
                return Just(sets)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .catch { _ in
                // Если ошибка при загрузке, возвращаем предустановленные наборы
                let defaultSets = DefaultSetsProvider.getDefaultSets()
                return self.localStore.saveSets(defaultSets)
                    .map { defaultSets }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSet(by id: String) -> AnyPublisher<FlashcardSet, Error> {
        return fetchSets()
            .tryMap { sets in
                guard let set = sets.first(where: { $0.id == id }) else {
                    throw DataServiceError.setNotFound
                }
                return set
            }
            .eraseToAnyPublisher()
    }
    
    func saveSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error> {
        return localStore.saveSet(set)
    }
    
    func deleteSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error> {
        return localStore.deleteSet(set)
    }
    
    func toggleFavorite(setId: String) -> AnyPublisher<Bool, Error> {
        return fetchSet(by: setId)
            .flatMap { set -> AnyPublisher<Bool, Error> in
                var updatedSet = set
                updatedSet.isFavorite.toggle()
                return self.saveSet(updatedSet)
                    .map { updatedSet.isFavorite }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Мои слова
    
    func getMyWordsSet() -> AnyPublisher<FlashcardSet, Error> {
        return fetchSet(by: AppConstants.SpecialSets.myWordsSetId)
            .catch { _ -> AnyPublisher<FlashcardSet, Error> in
                // Если набор не существует, создаем его
                let myWordsSet = FlashcardSet(
                    id: AppConstants.SpecialSets.myWordsSetId,
                    title: "Мои слова",
                    description: "Ваши личные слова и фразы для изучения",
                    workScenario: .smallTalk,
                    difficulty: .beginner,
                    cards: [],
                    author: nil,
                    isPremium: false,
                    averageStudyTime: 0,
                    totalTerms: 0,
                    createdAt: Date(),
                    lastStudied: nil,
                    masteryLevel: 0.0,
                    isFavorite: true
                )
                return self.saveSet(myWordsSet)
                    .map { myWordsSet }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func addWordToMyWords(_ card: Flashcard) -> AnyPublisher<Void, Error> {
        return getMyWordsSet()
            .flatMap { set -> AnyPublisher<Void, Error> in
                // Проверяем, нет ли уже такой карточки
                guard !set.cards.contains(where: { $0.id == card.id }) else {
                    return Just(())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                // Создаем новый массив карточек с добавленной карточкой
                let updatedCards = set.cards + [card]
                let updatedSet = FlashcardSet(
                    id: set.id,
                    title: set.title,
                    description: set.description,
                    workScenario: set.workScenario,
                    difficulty: set.difficulty,
                    cards: updatedCards,
                    author: set.author,
                    isPremium: set.isPremium,
                    averageStudyTime: updatedCards.count * 2,
                    totalTerms: updatedCards.count,
                    createdAt: set.createdAt,
                    lastStudied: set.lastStudied,
                    masteryLevel: set.masteryLevel,
                    isFavorite: set.isFavorite
                )
                
                return self.saveSet(updatedSet)
            }
            .eraseToAnyPublisher()
    }
    
    func removeWordFromMyWords(cardId: String) -> AnyPublisher<Void, Error> {
        return getMyWordsSet()
            .flatMap { set -> AnyPublisher<Void, Error> in
                // Создаем новый массив карточек без удаляемой карточки
                let updatedCards = set.cards.filter { $0.id != cardId }
                let updatedSet = FlashcardSet(
                    id: set.id,
                    title: set.title,
                    description: set.description,
                    workScenario: set.workScenario,
                    difficulty: set.difficulty,
                    cards: updatedCards,
                    author: set.author,
                    isPremium: set.isPremium,
                    averageStudyTime: updatedCards.count * 2,
                    totalTerms: updatedCards.count,
                    createdAt: set.createdAt,
                    lastStudied: set.lastStudied,
                    masteryLevel: set.masteryLevel,
                    isFavorite: set.isFavorite
                )
                
                return self.saveSet(updatedSet)
            }
            .eraseToAnyPublisher()
    }
    
    func saveLearningSession(_ session: LearningSession) -> AnyPublisher<Void, Error> {
        return localStore.saveSession(session)
    }
    
    func fetchTodaySessions() -> AnyPublisher<[LearningSession], Error> {
        return localStore.fetchSessions()
            .map { sessions in
                let today = Date().startOfDay
                return sessions.filter { session in
                    session.startTime >= today
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updateMastery(cardId: String, isCorrect: Bool) -> AnyPublisher<Double, Error> {
        // Упрощенная реализация - в реальности нужен алгоритм интервальных повторений
        return Just(0.5)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getOverallProgress() -> AnyPublisher<Double, Error> {
        return fetchSets()
            .map { sets in
                guard !sets.isEmpty else { return 0.0 }
                let totalMastery = sets.reduce(0.0) { $0 + $1.masteryLevel }
                return totalMastery / Double(sets.count)
            }
            .eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> AnyPublisher<User, Error> {
        return localStore.getUser()
            .tryMap { user in
                if let user = user {
                    return user
                } else {
                    // Создаем нового пользователя
                    let newUser = User(name: "User")
                    return newUser
                }
            }
            .flatMap { user in
                self.localStore.saveUser(user)
                    .map { user }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateUser(_ user: User) -> AnyPublisher<Void, Error> {
        return localStore.saveUser(user)
    }
}

enum DataServiceError: Error {
    case setNotFound
    case saveFailed
    case deleteFailed
}

// MARK: - UserDefaults Store Implementation

class UserDefaultsStore: LocalStoreProtocol {
    private let setsKey = "flashcard_sets"
    private let sessionsKey = "learning_sessions"
    private let userKey = "current_user"
    
    func fetchSets() -> AnyPublisher<[FlashcardSet], Error> {
        return Future { promise in
            do {
                guard let data = UserDefaults.standard.data(forKey: self.setsKey) else {
                    promise(.success([])) // Возвращаем пустой массив вместо ошибки
                    return
                }
                let sets = try JSONDecoder().decode([FlashcardSet].self, from: data)
                promise(.success(sets))
            } catch {
                promise(.success([])) // Возвращаем пустой массив при ошибке декодирования
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveSets(_ sets: [FlashcardSet]) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let data = try JSONEncoder().encode(sets)
                UserDefaults.standard.set(data, forKey: self.setsKey)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error> {
        return fetchSets()
            .catch { _ in Just([FlashcardSet]()).setFailureType(to: Error.self).eraseToAnyPublisher() }
            .flatMap { sets -> AnyPublisher<Void, Error> in
                var updatedSets = sets
                if let index = updatedSets.firstIndex(where: { $0.id == set.id }) {
                    updatedSets[index] = set
                } else {
                    updatedSets.append(set)
                }
                return self.saveSets(updatedSets)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error> {
        return fetchSets()
            .flatMap { sets -> AnyPublisher<Void, Error> in
                let updatedSets = sets.filter { $0.id != set.id }
                return self.saveSets(updatedSets)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSessions() -> AnyPublisher<[LearningSession], Error> {
        return Future { promise in
            guard let data = UserDefaults.standard.data(forKey: self.sessionsKey),
                  let sessions = try? JSONDecoder().decode([LearningSession].self, from: data) else {
                promise(.success([]))
                return
            }
            promise(.success(sessions))
        }
        .eraseToAnyPublisher()
    }
    
    func saveSession(_ session: LearningSession) -> AnyPublisher<Void, Error> {
        return fetchSessions()
            .flatMap { sessions -> AnyPublisher<Void, Error> in
                var updatedSessions = sessions
                updatedSessions.append(session)
                return Future { promise in
                    do {
                        let data = try JSONEncoder().encode(updatedSessions)
                        UserDefaults.standard.set(data, forKey: self.sessionsKey)
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User?, Error> {
        return Future { promise in
            do {
                guard let data = UserDefaults.standard.data(forKey: self.userKey) else {
                    promise(.success(nil))
                    return
                }
                let user = try JSONDecoder().decode(User.self, from: data)
                promise(.success(user))
            } catch {
                // При ошибке декодирования возвращаем nil
                promise(.success(nil))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveUser(_ user: User) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let data = try JSONEncoder().encode(user)
                UserDefaults.standard.set(data, forKey: self.userKey)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Mock Data Loader

class MockDataLoader: MockDataLoaderProtocol {
    func loadSets() -> AnyPublisher<[FlashcardSet], Error> {
        return Just([
            FlashcardSet.mock,
            FlashcardSet(
                id: "set_002",
                title: "Email Writing Basics",
                description: "Common phrases for professional email communication",
                workScenario: .emails,
                difficulty: .beginner,
                cards: Flashcard.mockArray,
                author: "BridgyAI Team",
                isPremium: false,
                averageStudyTime: 20,
                totalTerms: 15,
                createdAt: Date(),
                lastStudied: nil,
                masteryLevel: 0.0,
                isFavorite: false
            )
        ])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}

