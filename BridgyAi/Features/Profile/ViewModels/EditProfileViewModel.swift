//
//  EditProfileViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import Foundation
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var avatarImageData: Data?
    @Published var errorMessage: String = ""
    
    private let originalUser: User
    private let dataService: DataServiceProtocol = AppDependencies.shared.dataService
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.originalUser = user
        self.name = user.name
        self.avatarImageData = user.avatarImageData
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func removeAvatar() {
        avatarImageData = nil
    }
    
    func saveProfile(completion: @escaping () -> Void) {
        errorMessage = ""
        
        var updatedUser = originalUser
        updatedUser.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedUser.avatarImageData = avatarImageData
        
        dataService.updateUser(updatedUser)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] result in
                    if case .failure(let error) = result {
                        self?.errorMessage = "Ошибка при сохранении: \(error.localizedDescription)"
                    } else {
                        completion()
                    }
                },
                receiveValue: { _ in
                    completion()
                }
            )
            .store(in: &cancellables)
    }
}
