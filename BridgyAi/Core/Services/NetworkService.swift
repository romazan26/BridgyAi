//
//  NetworkService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func syncSets() -> AnyPublisher<[FlashcardSet], Error>
    func uploadSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error>
}

class NetworkService: NetworkServiceProtocol {
    // Заглушка для будущей синхронизации с сервером
    func syncSets() -> AnyPublisher<[FlashcardSet], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func uploadSet(_ set: FlashcardSet) -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


