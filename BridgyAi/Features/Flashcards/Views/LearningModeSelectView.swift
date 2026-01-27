//
//  LearningModeSelectView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct LearningModeSelectView: View {
    let set: FlashcardSet
    @Environment(\.dismiss) var dismiss
    @State private var selectedMode: LearningMode?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.large) {
                    // Информация о наборе
                    SetInfoCard(set: set)
                    
                    // Режимы обучения
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Выберите режим обучения")
                            .font(AppConstants.Fonts.headline)
                            .padding(.horizontal)
                        
                        ForEach(LearningMode.allCases, id: \.self) { mode in
                            Button(action: {
                                selectedMode = mode
                            }) {
                                ModeCard(mode: mode)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Начать обучение")
            .navigationBarTitleDisplayMode(.large)
            .background(AppConstants.Colors.bridgyBackground)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedMode) { mode in
                modeView(for: mode)
            }
        }
    }
    
    @ViewBuilder
    private func modeView(for mode: LearningMode) -> some View {
        if set.cards.isEmpty {
            EmptyStateView(
                icon: "exclamationmark.triangle",
                title: "Набор пуст",
                message: "В этом наборе нет карточек для обучения",
                actionTitle: "Закрыть",
                action: { selectedMode = nil }
            )
        } else {
            switch mode {
            case .flashcards:
                FlashcardLearningView(set: set)
            case .write:
                WriteModeView(set: set)
            case .speak:
                SpeakModeView(set: set)
            case .test:
                TestModeView(set: set)
            case .match:
                MatchGameView(set: set)
            case .gravity:
                GravityGameView(set: set)
            }
        }
    }
}

struct ModeCard: View {
    let mode: LearningMode
    
    var body: some View {
        CardView {
            HStack(spacing: AppConstants.Spacing.medium) {
                Image(systemName: mode.icon)
                    .font(.title2)
                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.title)
                        .font(AppConstants.Fonts.headline)
                    
                    Text(modeDescription(for: mode))
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func modeDescription(for mode: LearningMode) -> String {
        switch mode {
        case .flashcards:
            return "Flip cards to learn"
        case .write:
            return "Type the answer"
        case .speak:
            return "Practice pronunciation"
        case .test:
            return "Multiple choice quiz"
        case .match:
            return "Match pairs"
        case .gravity:
            return "Fast-paced typing"
        }
    }
}

#Preview {
    LearningModeSelectView(set: FlashcardSet.mock)
}

