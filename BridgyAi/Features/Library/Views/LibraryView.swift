//
//  LibraryView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var selectedSet: FlashcardSet?
    @State private var showingCreateSet = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    // Поиск и фильтры
                    SearchAndFiltersView(
                        searchText: $viewModel.searchText,
                        selectedScenario: $viewModel.selectedScenario,
                        selectedDifficulty: $viewModel.selectedDifficulty
                    )
                    
                    // Список наборов
                    if viewModel.isLoading {
                        LoadingView(message: "Загрузка наборов...")
                    } else if viewModel.filteredSets.isEmpty {
                        EmptyStateView(
                            icon: "book.closed",
                            title: "Наборы не найдены",
                            message: viewModel.searchText.isEmpty
                                ? "Создайте свой первый набор карточек для начала обучения"
                                : "Попробуйте изменить поиск или фильтры",
                            actionTitle: viewModel.searchText.isEmpty ? "Создать набор" : nil,
                            action: viewModel.searchText.isEmpty ? {
                                showingCreateSet = true
                            } : nil
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: AppConstants.Spacing.medium) {
                                ForEach(viewModel.filteredSets) { set in
                                    SetRowView(set: set) {
                                        selectedSet = set
                                    } onToggleFavorite: {
                                        viewModel.toggleFavorite(setId: set.id)
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, 80) // Отступ для floating button
                        }
                    }
                }
                
                // Floating Action Button для создания набора
                Button(action: {
                    showingCreateSet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Создать набор")
                            .font(AppConstants.Fonts.headline)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, AppConstants.Spacing.large)
                    .padding(.vertical, AppConstants.Spacing.medium)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.bridgyPrimary,
                                AppConstants.Colors.bridgySecondary
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(AppConstants.CornerRadius.large)
                    .shadow(color: AppConstants.Colors.bridgyPrimary.opacity(0.4), radius: 10, x: 0, y: 4)
                }
                .padding(.trailing, AppConstants.Spacing.medium)
                .padding(.bottom, AppConstants.Spacing.medium)
            }
            .navigationTitle("Библиотека")
            .background(AppConstants.Colors.bridgyBackground)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateSet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    }
                }
            }
            .onAppear {
                if viewModel.sets.isEmpty && !viewModel.isLoading {
                    viewModel.loadSets()
                }
            }
            .sheet(item: $selectedSet) { set in
                SetDetailView(set: set)
            }
            .sheet(isPresented: $showingCreateSet) {
                CreateSetView()
            }
            .onChange(of: showingCreateSet) { _, isShowing in
                if !isShowing {
                    // Обновляем список после закрытия экрана создания
                    viewModel.loadSets()
                }
            }
        }
    }
}

struct SearchAndFiltersView: View {
    @Binding var searchText: String
    @Binding var selectedScenario: WorkScenario?
    @Binding var selectedDifficulty: DifficultyLevel?
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.medium) {
            // Поиск
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search sets...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(AppConstants.CornerRadius.medium)
            .padding(.horizontal)
            
            // Фильтры
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppConstants.Spacing.small) {
                    // Фильтр по сценарию
                    ForEach(WorkScenario.allCases, id: \.self) { scenario in
                        FilterChip(
                            title: scenario.title,
                            icon: scenario.icon,
                            isSelected: selectedScenario == scenario,
                            action: {
                                selectedScenario = selectedScenario == scenario ? nil : scenario
                            }
                        )
                    }
                    
                    // Фильтр по сложности
                    ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                        FilterChip(
                            title: difficulty.rawValue,
                            isSelected: selectedDifficulty == difficulty,
                            action: {
                                selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, AppConstants.Spacing.small)
        .background(AppConstants.Colors.bridgyCard)
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(AppConstants.Fonts.caption)
            }
            .padding(.horizontal, AppConstants.Spacing.small)
            .padding(.vertical, 6)
            .background(isSelected ? AppConstants.Colors.bridgyPrimary : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : AppConstants.Colors.bridgyText)
            .cornerRadius(AppConstants.CornerRadius.small)
        }
    }
}

struct SetRowView: View {
    let set: FlashcardSet
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        CardView {
            HStack(spacing: AppConstants.Spacing.medium) {
                Image(systemName: set.workScenario.icon)
                    .font(.title2)
                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(set.title)
                        .font(AppConstants.Fonts.headline)
                        .lineLimit(1)
                    
                    Text(set.description)
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: AppConstants.Spacing.small) {
                        BadgeView(text: set.difficulty.rawValue, color: set.difficulty.color)
                        Text("\(set.totalTerms) cards")
                            .font(AppConstants.Fonts.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onToggleFavorite) {
                    Image(systemName: set.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(set.isFavorite ? AppConstants.Colors.bridgySecondary : .secondary)
                }
            }
        }
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    LibraryView()
}

