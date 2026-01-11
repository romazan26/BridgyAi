//
//  ProgressView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct ProgressView: View {
    @StateObject private var viewModel = ProgressViewModel()
    @State private var selectedTab: AchievementTab = .all
    
    enum AchievementTab {
        case all, unlocked, locked
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.large) {
                    // Общий прогресс
                    CardView {
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                            Text("Общий прогресс")
                                .font(AppConstants.Fonts.headline)
                            
                            ProgressBar(progress: viewModel.overallProgress)
                            
                            Text("\(Int(viewModel.overallProgress * 100))% мастерства")
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Статистика
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Статистика")
                            .font(AppConstants.Fonts.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: AppConstants.Spacing.medium) {
                            StatisticCard(
                                title: "Карточек изучено",
                                value: "\(viewModel.totalCardsStudied)",
                                icon: "rectangle.stack",
                                color: AppConstants.Colors.bridgyPrimary
                            )
                            
                            StatisticCard(
                                title: "Время обучения",
                                value: AppFormatters.formatStudyTime(viewModel.totalStudyTimeMinutes),
                                icon: "clock",
                                color: AppConstants.Colors.bridgySuccess
                            )
                            
                            StatisticCard(
                                title: "Серия дней",
                                value: "\(viewModel.streakDays)",
                                icon: "flame",
                                color: AppConstants.Colors.bridgyWarning
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Система наград
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        HStack {
                            Text("Награды")
                                .font(AppConstants.Fonts.headline)
                            
                            Spacer()
                            
                            Text("\(viewModel.unlockedCount)/\(viewModel.totalCount)")
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        // Табы
                        HStack(spacing: 0) {
                            TabButton(
                                title: "Все",
                                isSelected: selectedTab == .all,
                                action: { selectedTab = .all }
                            )
                            TabButton(
                                title: "Получено (\(viewModel.unlockedCount))",
                                isSelected: selectedTab == .unlocked,
                                action: { selectedTab = .unlocked }
                            )
                            TabButton(
                                title: "Заблокировано",
                                isSelected: selectedTab == .locked,
                                action: { selectedTab = .locked }
                            )
                        }
                        .padding(.horizontal)
                        
                        // Список наград
                        if viewModel.isLoading {
                            LoadingView(message: "Загрузка наград...")
                                .frame(height: 200)
                        } else {
                            let displayedAchievements: [Achievement] = {
                                switch selectedTab {
                                case .all: return viewModel.achievements
                                case .unlocked: return viewModel.unlockedAchievements
                                case .locked: return viewModel.lockedAchievements
                                }
                            }()
                            
                            if displayedAchievements.isEmpty {
                                EmptyStateView(
                                    icon: "trophy",
                                    title: selectedTab == .unlocked ? "Нет полученных наград" : "Нет заблокированных наград",
                                    message: selectedTab == .unlocked 
                                        ? "Продолжайте заниматься, чтобы получить награды!"
                                        : "Все награды получены!",
                                    actionTitle: nil,
                                    action: nil
                                )
                                .frame(height: 200)
                            } else {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppConstants.Spacing.medium) {
                                    ForEach(displayedAchievements) { achievement in
                                        AchievementCard(achievement: achievement)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Прогресс")
            .background(AppConstants.Colors.bridgyBackground)
            .task {
                guard !viewModel.hasLoadedData && !viewModel.isLoading else { return }
                viewModel.loadData()
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppConstants.Fonts.caption)
                .foregroundColor(isSelected ? .white : AppConstants.Colors.bridgyText)
                .padding(.horizontal, AppConstants.Spacing.medium)
                .padding(.vertical, AppConstants.Spacing.small)
                .background(isSelected ? AppConstants.Colors.bridgyPrimary : Color(.systemGray6))
                .cornerRadius(AppConstants.CornerRadius.small)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        ZStack {
            // Градиентный фон в зависимости от редкости
            LinearGradient(
                gradient: Gradient(colors: achievement.type.rarity.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: AppConstants.Spacing.small) {
                // Иконка
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.type.color.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: achievement.type.icon)
                        .font(.system(size: 30))
                        .foregroundColor(achievement.isUnlocked ? achievement.type.color : .gray)
                        .opacity(achievement.isUnlocked ? 1.0 : 0.5)
                }
                
                // Название
                Text(achievement.type.title)
                    .font(AppConstants.Fonts.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(achievement.isUnlocked ? AppConstants.Colors.bridgyText : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 32)
                
                // Прогресс (если не разблокировано)
                if !achievement.isUnlocked && achievement.progress > 0 {
                    ProgressBar(progress: achievement.progress)
                        .frame(height: 4)
                }
                
                // Бейдж редкости
                if achievement.isUnlocked {
                    Text(achievement.type.rarity.rawValue.capitalized)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(achievement.type.color)
                        .cornerRadius(4)
                }
            }
            .padding(AppConstants.Spacing.small)
        }
        .cornerRadius(AppConstants.CornerRadius.medium)
        .shadow(color: achievement.isUnlocked ? achievement.type.color.opacity(0.3) : Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                .stroke(achievement.isUnlocked ? achievement.type.color.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        CardView {
            VStack(spacing: AppConstants.Spacing.small) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(AppConstants.Fonts.headline)
                
                Text(title)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ProgressView()
}


