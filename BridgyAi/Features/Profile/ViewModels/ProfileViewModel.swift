//
//  ProfileViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "User"
    @Published var userLevel: DifficultyLevel = .beginner
    @Published var isPremium: Bool = false
    
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.dataService = dataService
    }
    
    func loadUser() {
        dataService.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] user in
                    self?.userName = user.name
                    self?.userLevel = user.level
                    self?.isPremium = user.isPremium
                }
            )
            .store(in: &cancellables)
    }
}


