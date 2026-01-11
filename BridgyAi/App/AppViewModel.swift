//
//  AppViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isOnboardingCompleted = false
    @Published var isLoading = false
    
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.dataService = dataService
        checkOnboardingStatus()
        // Откладываем загрузку пользователя до полной инициализации
        DispatchQueue.main.async { [weak self] in
            self?.loadUser()
        }
    }
    
    private func loadUser() {
        isLoading = true
        dataService.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("Error loading user: \(error)")
                    }
                },
                receiveValue: { [weak self] user in
                    self?.currentUser = user
                }
            )
            .store(in: &cancellables)
    }
    
    private func checkOnboardingStatus() {
        // Безопасная проверка статуса онбординга
        do {
            isOnboardingCompleted = UserDefaults.standard.bool(forKey: "onboarding_completed")
        } catch {
            isOnboardingCompleted = false
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
    }
}

