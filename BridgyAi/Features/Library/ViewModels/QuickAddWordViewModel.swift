//
//  QuickAddWordViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import Foundation
import Combine

class QuickAddWordViewModel: ObservableObject {
    @Published var front: String = ""
    @Published var back: String = ""
    @Published var example: String = ""
    @Published var hint: String = ""
    @Published var errorMessage: String = ""
    
    private let dataService: DataServiceProtocol = AppDependencies.shared.dataService
    private var cancellables = Set<AnyCancellable>()
    
    var isValid: Bool {
        !front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func saveWord(completion: @escaping () -> Void) {
        errorMessage = ""
        
        let card = Flashcard(
            id: UUID().uuidString,
            front: front.trimmingCharacters(in: .whitespacesAndNewlines),
            back: back.trimmingCharacters(in: .whitespacesAndNewlines),
            phonetic: nil,
            example: example.isEmpty ? nil : example.trimmingCharacters(in: .whitespacesAndNewlines),
            hint: hint.isEmpty ? nil : hint.trimmingCharacters(in: .whitespacesAndNewlines),
            audioURL: nil,
            imageURL: nil,
            tags: []
        )
        
        dataService.addWordToMyWords(card)
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
