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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Приветствие
                    HeaderView(userName: viewModel.userName)
                    
                    // Ежедневная цель
                    DailyGoalCard(
                        progress: viewModel.dailyGoalProgress,
                        streak: viewModel.streakDays
                    )
                    
                    // Рекомендуемые наборы
                    RecommendedSetsView(
                        sets: viewModel.recommendedSets,
                        onSelectSet: { set in
                            selectedSet = set
                        }
                    )
                    
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
                        }
                    )
                    
                    // Недавняя активность
                    RecentActivityView(sessions: viewModel.recentSessions)
                }
                .padding()
            }
            .navigationTitle("Сегодня")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NotificationButton(count: viewModel.notificationCount)
                }
            }
            .background(AppConstants.Colors.bridgyBackground)
            .task {
                guard !viewModel.hasLoadedData && !viewModel.isLoading else { return }
                viewModel.loadData()
                viewModel.hasLoadedData = true
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
        }
    }
}

struct HeaderView: View {
    let userName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(userName)!")
                    .font(AppConstants.Fonts.title)
                    .foregroundColor(AppConstants.Colors.bridgyText)
                
                Text("Ready to learn?")
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DailyGoalCard: View {
    let progress: Double
    let streak: Int
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                HStack {
                Text("Ежедневная цель")
                    .font(AppConstants.Fonts.headline)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(AppConstants.Colors.bridgyWarning)
                        Text("\(streak)")
                            .font(AppConstants.Fonts.headline)
                    }
                }
                
                ProgressBar(progress: progress)
                
                Text("\(Int(progress * 100))% выполнено")
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct RecommendedSetsView: View {
    let sets: [FlashcardSet]
    let onSelectSet: (FlashcardSet) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Рекомендуется для вас")
                .font(AppConstants.Fonts.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppConstants.Spacing.medium) {
                    ForEach(sets) { set in
                        SetCardView(set: set) {
                            onSelectSet(set)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SetCardView: View {
    let set: FlashcardSet
    let onTap: () -> Void
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                HStack {
                    Image(systemName: set.workScenario.icon)
                        .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    
                    Spacer()
                    
                    if set.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(AppConstants.Colors.bridgySecondary)
                    }
                }
                
                Text(set.title)
                    .font(AppConstants.Fonts.headline)
                    .lineLimit(2)
                
                Text(set.description)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    BadgeView(text: set.difficulty.rawValue, color: set.difficulty.color)
                    Spacer()
                    Text("\(set.totalTerms) карточек")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200)
        }
        .onTapGesture(perform: onTap)
    }
}

struct QuickActionsView: View {
    let onStartQuickSession: () -> Void
    let onCreateSet: () -> Void
    let onPracticeWeak: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Быстрые действия")
                .font(AppConstants.Fonts.headline)
                .padding(.horizontal)
            
            HStack(spacing: AppConstants.Spacing.medium) {
                QuickActionButton(
                    title: "Быстрое изучение",
                    icon: "bolt.fill",
                    color: AppConstants.Colors.bridgyPrimary,
                    action: onStartQuickSession
                )
                
                QuickActionButton(
                    title: "Создать набор",
                    icon: "plus.circle.fill",
                    color: AppConstants.Colors.bridgySecondary,
                    action: onCreateSet
                )
                
                QuickActionButton(
                    title: "Слабые места",
                    icon: "exclamationmark.triangle.fill",
                    color: AppConstants.Colors.bridgyWarning,
                    action: onPracticeWeak
                )
            }
            .padding(.horizontal)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(AppConstants.Fonts.caption)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppConstants.Spacing.medium)
            .background(color)
            .cornerRadius(AppConstants.CornerRadius.medium)
        }
    }
}

struct RecentActivityView: View {
    let sessions: [LearningSession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Недавняя активность")
                .font(AppConstants.Fonts.headline)
                .padding(.horizontal)
            
            if sessions.isEmpty {
                EmptyStateView(
                    icon: "clock",
                    title: "Нет недавней активности",
                    message: "Начните обучение, чтобы увидеть свой прогресс здесь"
                )
                .frame(height: 150)
            } else {
                ForEach(sessions) { session in
                    ActivityRowView(session: session)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ActivityRowView: View {
    let session: LearningSession
    
    var body: some View {
        HStack {
            Image(systemName: session.mode.icon)
                .foregroundColor(AppConstants.Colors.bridgyPrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.mode.title)
                    .font(AppConstants.Fonts.body)
                
                Text("\(session.cardsStudied) карточек • \(AppFormatters.formatDuration(session.duration))")
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(session.startTime.formatted(style: .short))
                .font(AppConstants.Fonts.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .bridgyCardStyle()
    }
}

struct NotificationButton: View {
    let count: Int
    
    var body: some View {
        Button(action: {}) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .foregroundColor(AppConstants.Colors.bridgyText)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(AppConstants.Colors.bridgyError)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}

struct SetDetailView: View {
    let set: FlashcardSet
    @Environment(\.dismiss) var dismiss
    @State private var showingLearningMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.large) {
                    // Информация о наборе
                    SetInfoCard(set: set)
                    
                    // Статистика
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Статистика")
                            .font(AppConstants.Fonts.headline)
                        
                        HStack {
                            StatCard(title: "Мастерство", value: "\(Int(set.masteryLevel * 100))%")
                            StatCard(title: "Карточки", value: "\(set.totalTerms)")
                            StatCard(title: "Время", value: "\(set.averageStudyTime) мин")
                        }
                    }
                    
                    // Кнопка начала обучения
                    if !set.cards.isEmpty {
                        PrimaryButton("Начать обучение", icon: "play.fill") {
                            showingLearningMode = true
                        }
                    } else {
                        CardView {
                            Text("В этом наборе нет карточек")
                                .font(AppConstants.Fonts.body)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(set.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingLearningMode) {
                LearningModeSelectView(set: set)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        CardView {
            VStack(spacing: 4) {
                Text(value)
                    .font(AppConstants.Fonts.headline)
                Text(title)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}

