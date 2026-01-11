//
//  WeakSpotsView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI
import Combine

struct WeakSpotsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = WeakSpotsViewModel()
    @State private var selectedSet: FlashcardSet?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoadingView(message: "Загрузка слабых мест...")
                } else if viewModel.weakSets.isEmpty {
                    EmptyStateView(
                        icon: "checkmark.circle",
                        title: "Нет слабых мест",
                        message: "Отлично! Вы хорошо знаете все карточки. Продолжайте практиковаться!",
                        actionTitle: nil,
                        action: nil
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppConstants.Spacing.medium) {
                            ForEach(viewModel.weakSets) { set in
                                SetRowView(set: set) {
                                    selectedSet = set
                                } onToggleFavorite: {
                                    // Toggle favorite
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Слабые места")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.loadWeakSpots()
            }
            .sheet(item: $selectedSet) { set in
                LearningModeSelectView(set: set)
            }
        }
    }
}

class WeakSpotsViewModel: ObservableObject {
    @Published var weakSets: [FlashcardSet] = []
    @Published var isLoading = false
    
    private let dataService: DataServiceProtocol = AppDependencies.shared.dataService
    private var cancellables = Set<AnyCancellable>()
    
    func loadWeakSpots() {
        isLoading = true
        dataService.fetchSets()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] sets in
                    // Находим наборы с низким уровнем мастерства (< 0.5)
                    self?.weakSets = sets.filter { $0.masteryLevel < 0.5 }
                        .sorted { $0.masteryLevel < $1.masteryLevel }
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}

#Preview {
    WeakSpotsView()
}

