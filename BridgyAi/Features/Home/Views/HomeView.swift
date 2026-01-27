//
//  HomeView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedSet: FlashcardSet?
    @State private var showingCreateSet = false
    @State private var showingWeakSpots = false
    @State private var showingQuickAddWord = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Анимированный фон
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                    // Приветствие
                    HeaderView(userName: viewModel.userName)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    
                    // Ежедневная цель
                    DailyGoalCard(
                        progress: viewModel.dailyGoalProgress,
                        streak: viewModel.streakDays
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    
                    // Рекомендуемые наборы
                    RecommendedSetsView(
                        sets: viewModel.recommendedSets,
                        onSelectSet: { set in
                            selectedSet = set
                        }
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    
                    // Быстрые действия
                    QuickActionsView(
                        onStartQuickSession: {
                            if let firstSet = viewModel.recommendedSets.first, !firstSet.cards.isEmpty {
                                selectedSet = firstSet
                            } else {
                                // Если нет наборов, показываем библиотеку
                                showingCreateSet = true
                            }
                        },
                        onCreateSet: {
                            showingCreateSet = true
                        },
                        onPracticeWeak: {
                            showingWeakSpots = true
                        },
                        onAddWord: {
                            showingQuickAddWord = true
                        }
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    
                    // Недавняя активность
                    RecentActivityView(sessions: viewModel.recentSessions)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Сегодня")
            .task {
                guard !viewModel.hasLoadedData && !viewModel.isLoading else { return }
                viewModel.loadData()
                viewModel.hasLoadedData = true
            }
            .onAppear {
                // Обновляем данные пользователя при возврате на экран
                if viewModel.hasLoadedData {
                    viewModel.loadUserData()
                }
            }
            .sheet(item: $selectedSet) { set in
                if !set.cards.isEmpty {
                    SetDetailView(set: set)
                } else {
                    NavigationStack {
                        EmptyStateView(
                            icon: "exclamationmark.triangle",
                            title: "Набор пуст",
                            message: "В этом наборе нет карточек",
                            actionTitle: "Закрыть",
                            action: { selectedSet = nil }
                        )
                        .navigationTitle(set.title)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Готово") {
                                    selectedSet = nil
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreateSet) {
                CreateSetView()
            }
            .sheet(isPresented: $showingWeakSpots) {
                WeakSpotsView()
            }
            .sheet(isPresented: $showingQuickAddWord) {
                QuickAddWordView()
            }
            .onChange(of: showingQuickAddWord) { _, isShowing in
                if !isShowing {
                    // Обновляем данные после добавления слова
                    viewModel.loadData()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

