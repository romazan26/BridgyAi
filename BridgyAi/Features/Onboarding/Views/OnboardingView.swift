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
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppConstants.Spacing.xLarge) {
                Spacer()
                    .frame(height: 60)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.bridgyPrimary,
                                AppConstants.Colors.bridgySecondary
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: AppConstants.Colors.bridgyPrimary.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(spacing: AppConstants.Spacing.medium) {
                    Text("Добро пожаловать в BridgyAI")
                        .font(AppConstants.Fonts.title)
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppConstants.Colors.bridgyText)
                        .padding(.horizontal, AppConstants.Spacing.large)
                    
                    Text("Изучайте бизнес-английский с помощью AI-карточек, разработанных для профессионалов")
                        .font(AppConstants.Fonts.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, AppConstants.Spacing.large)
                }
                
                Spacer()
                
                PrimaryButton("Начать", icon: "arrow.right") {
                    onContinue()
                }
                .padding(.horizontal, AppConstants.Spacing.large)
                .padding(.bottom, AppConstants.Spacing.xLarge + 20)
            }
        }
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
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppConstants.Spacing.large) {
                VStack(spacing: AppConstants.Spacing.small) {
                    Text("Какова ваша цель?")
                        .font(AppConstants.Fonts.title)
                        .foregroundColor(AppConstants.Colors.bridgyText)
                    
                    Text("Выберите, на чем вы хотите сосредоточиться")
                        .font(AppConstants.Fonts.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppConstants.Spacing.xLarge + 20)
                .padding(.horizontal, AppConstants.Spacing.large)
                
                VStack(spacing: AppConstants.Spacing.medium) {
                    ForEach(goals, id: \.self) { goal in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedGoal = goal
                            }
                        }) {
                            HStack(spacing: AppConstants.Spacing.medium) {
                                Text(goal)
                                    .font(AppConstants.Fonts.body)
                                    .foregroundColor(AppConstants.Colors.bridgyText)
                                
                                Spacer()
                                
                                if selectedGoal == goal {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding(AppConstants.Spacing.medium)
                            .background(
                                selectedGoal == goal
                                    ? LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppConstants.Colors.bridgyPrimary.opacity(0.15),
                                            AppConstants.Colors.bridgySecondary.opacity(0.1)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    : LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(.systemGray6),
                                            Color(.systemGray6).opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                            )
                            .cornerRadius(AppConstants.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                    .stroke(
                                        selectedGoal == goal
                                            ? LinearGradient(
                                                gradient: Gradient(colors: [
                                                    AppConstants.Colors.bridgyPrimary,
                                                    AppConstants.Colors.bridgySecondary
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            : LinearGradient(
                                                gradient: Gradient(colors: [Color.clear]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(
                                color: selectedGoal == goal
                                    ? AppConstants.Colors.bridgyPrimary.opacity(0.2)
                                    : Color.clear,
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.large)
                
                Spacer()
                
                PrimaryButton("Продолжить", icon: "arrow.right", isEnabled: selectedGoal != nil) {
                    onContinue()
                }
                .padding(.horizontal, AppConstants.Spacing.large)
                .padding(.bottom, AppConstants.Spacing.xLarge + 20)
            }
        }
    }
}

struct LevelTestView: View {
    let onComplete: () -> Void
    @State private var selectedLevel: DifficultyLevel = .beginner
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppConstants.Spacing.large) {
                VStack(spacing: AppConstants.Spacing.small) {
                    Text("Какой у вас уровень?")
                        .font(AppConstants.Fonts.title)
                        .foregroundColor(AppConstants.Colors.bridgyText)
                    
                    Text("Мы подберем контент специально для вас")
                        .font(AppConstants.Fonts.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppConstants.Spacing.xLarge + 20)
                .padding(.horizontal, AppConstants.Spacing.large)
                
                VStack(spacing: AppConstants.Spacing.medium) {
                    ForEach(DifficultyLevel.allCases, id: \.self) { level in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedLevel = level
                            }
                        }) {
                            VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                                HStack {
                                    HStack(spacing: AppConstants.Spacing.small) {
                                        Circle()
                                            .fill(
                                                selectedLevel == level
                                                    ? LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            AppConstants.Colors.bridgyPrimary,
                                                            AppConstants.Colors.bridgySecondary
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                    : LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color.gray.opacity(0.3),
                                                            Color.gray.opacity(0.2)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                            )
                                            .frame(width: 12, height: 12)
                                        
                                        Text(level.rawValue)
                                            .font(AppConstants.Fonts.headline)
                                            .foregroundColor(AppConstants.Colors.bridgyText)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedLevel == level {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        AppConstants.Colors.bridgyPrimary,
                                                        AppConstants.Colors.bridgySecondary
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                }
                                
                                Text(levelDescription(for: level))
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(AppConstants.Spacing.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                selectedLevel == level
                                    ? LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppConstants.Colors.bridgyPrimary.opacity(0.15),
                                            AppConstants.Colors.bridgySecondary.opacity(0.1)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    : LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(.systemGray6),
                                            Color(.systemGray6).opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                            )
                            .cornerRadius(AppConstants.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                    .stroke(
                                        selectedLevel == level
                                            ? LinearGradient(
                                                gradient: Gradient(colors: [
                                                    AppConstants.Colors.bridgyPrimary,
                                                    AppConstants.Colors.bridgySecondary
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            : LinearGradient(
                                                gradient: Gradient(colors: [Color.clear]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(
                                color: selectedLevel == level
                                    ? AppConstants.Colors.bridgyPrimary.opacity(0.2)
                                    : Color.clear,
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.large)
                
                Spacer()
                
                PrimaryButton("Начать обучение", icon: "checkmark.circle.fill") {
                    onComplete()
                }
                .padding(.horizontal, AppConstants.Spacing.large)
                .padding(.bottom, AppConstants.Spacing.xLarge + 20)
            }
        }
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

