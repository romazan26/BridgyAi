//
//  AppDependencies.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

class AppDependencies {
    static let shared = AppDependencies()
    
    let dataService: DataServiceProtocol
    lazy var speechService: SpeechServiceProtocol = SpeechService()
    let progressService: ProgressServiceProtocol
    let achievementService: AchievementServiceProtocol
    let aiService: AIServiceProtocol
    let networkService: NetworkServiceProtocol
    
    private init() {
        self.dataService = DataService()
        // speechService создается лениво при первом обращении
        self.progressService = ProgressService(dataService: dataService)
        self.achievementService = AchievementService(dataService: dataService)
        self.aiService = AIService()
        self.networkService = NetworkService()
    }
}

