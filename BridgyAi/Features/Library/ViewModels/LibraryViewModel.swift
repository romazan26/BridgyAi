//
//  LibraryViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var sets: [FlashcardSet] = []
    @Published var filteredSets: [FlashcardSet] = []
    @Published var searchText: String = ""
    @Published var selectedScenario: WorkScenario?
    @Published var selectedDifficulty: DifficultyLevel?
    @Published var isLoading = false
    
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataServiceProtocol = AppDependencies.shared.dataService) {
        self.dataService = dataService
        
        $searchText
            .combineLatest($selectedScenario, $selectedDifficulty)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func loadSets() {
        // Предотвращаем множественные одновременные загрузки
        guard !isLoading else { return }
        
        isLoading = true
        dataService.fetchSets()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] sets in
                    self?.sets = sets
                    self?.applyFilters()
                }
            )
            .store(in: &cancellables)
    }
    
    func toggleFavorite(setId: String) {
        dataService.toggleFavorite(setId: setId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.loadSets()
                }
            )
            .store(in: &cancellables)
    }
    
    private func applyFilters() {
        var filtered = sets
        
        if !searchText.isEmpty {
            filtered = filtered.filter { set in
                set.title.localizedCaseInsensitiveContains(searchText) ||
                set.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let scenario = selectedScenario {
            filtered = filtered.filter { $0.workScenario == scenario }
        }
        
        if let difficulty = selectedDifficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }
        
        filteredSets = filtered
    }
}


