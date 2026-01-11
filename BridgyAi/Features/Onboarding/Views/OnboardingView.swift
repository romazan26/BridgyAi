//
//  OnboardingView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            WelcomeView(onContinue: {
                withAnimation {
                    currentPage = 1
                }
            })
            .tag(0)
            
            GoalSelectionView(onContinue: {
                withAnimation {
                    currentPage = 2
                }
            })
            .tag(1)
            
            LevelTestView(onComplete: {
                appViewModel.completeOnboarding()
            })
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct WelcomeView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.xLarge) {
            Spacer()
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(AppConstants.Colors.bridgyPrimary)
            
            VStack(spacing: AppConstants.Spacing.medium) {
                Text("Добро пожаловать в BridgyAI")
                    .font(AppConstants.Fonts.title)
                    .multilineTextAlignment(.center)
                
                Text("Изучайте бизнес-английский с помощью AI-карточек, разработанных для профессионалов")
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            PrimaryButton("Начать", icon: "arrow.right") {
                onContinue()
            }
            .padding(.horizontal, AppConstants.Spacing.large)
            .padding(.bottom, AppConstants.Spacing.xLarge)
        }
        .background(AppConstants.Colors.bridgyBackground)
    }
}

struct GoalSelectionView: View {
    let onContinue: () -> Void
    @State private var selectedGoal: String?
    
    let goals = [
        "Улучшить написание email",
        "Лучшие презентации",
        "Собеседования",
        "Деловые встречи",
        "Общее улучшение"
    ]
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.large) {
            VStack(spacing: AppConstants.Spacing.small) {
                Text("Какова ваша цель?")
                    .font(AppConstants.Fonts.title)
                
                Text("Выберите, на чем вы хотите сосредоточиться")
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
            }
            .padding(.top, AppConstants.Spacing.xLarge)
            
            VStack(spacing: AppConstants.Spacing.medium) {
                ForEach(goals, id: \.self) { goal in
                    Button(action: {
                        selectedGoal = goal
                    }) {
                        HStack {
                            Text(goal)
                                .font(AppConstants.Fonts.body)
                            Spacer()
                            if selectedGoal == goal {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                            }
                        }
                        .padding()
                        .background(selectedGoal == goal ? AppConstants.Colors.bridgyPrimary.opacity(0.1) : Color(.systemGray6))
                        .cornerRadius(AppConstants.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                .stroke(
                                    selectedGoal == goal ? AppConstants.Colors.bridgyPrimary : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .foregroundColor(AppConstants.Colors.bridgyText)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            PrimaryButton("Продолжить", icon: "arrow.right", isEnabled: selectedGoal != nil) {
                onContinue()
            }
            .padding(.horizontal, AppConstants.Spacing.large)
            .padding(.bottom, AppConstants.Spacing.xLarge)
        }
        .background(AppConstants.Colors.bridgyBackground)
    }
}

struct LevelTestView: View {
    let onComplete: () -> Void
    @State private var selectedLevel: DifficultyLevel = .beginner
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.large) {
            VStack(spacing: AppConstants.Spacing.small) {
                Text("Какой у вас уровень?")
                    .font(AppConstants.Fonts.title)
                
                Text("Мы подберем контент специально для вас")
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
            }
            .padding(.top, AppConstants.Spacing.xLarge)
            
            VStack(spacing: AppConstants.Spacing.medium) {
                ForEach(DifficultyLevel.allCases, id: \.self) { level in
                    Button(action: {
                        selectedLevel = level
                    }) {
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                            HStack {
                                Text(level.rawValue)
                                    .font(AppConstants.Fonts.headline)
                                Spacer()
                                if selectedLevel == level {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                }
                            }
                            
                            Text(levelDescription(for: level))
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedLevel == level ? AppConstants.Colors.bridgyPrimary.opacity(0.1) : Color(.systemGray6))
                        .cornerRadius(AppConstants.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                .stroke(
                                    selectedLevel == level ? AppConstants.Colors.bridgyPrimary : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .foregroundColor(AppConstants.Colors.bridgyText)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            PrimaryButton("Начать обучение", icon: "checkmark.circle.fill") {
                onComplete()
            }
            .padding(.horizontal, AppConstants.Spacing.large)
            .padding(.bottom, AppConstants.Spacing.xLarge)
        }
        .background(AppConstants.Colors.bridgyBackground)
    }
    
    private func levelDescription(for level: DifficultyLevel) -> String {
        switch level {
        case .beginner:
            return "Базовые фразы и словарь"
        case .intermediate:
            return "Разговорный бизнес-английский"
        case .advanced:
            return "Сложная профессиональная коммуникация"
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}

