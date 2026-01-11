//
//  FlashcardLearningView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct FlashcardLearningView: View {
    let set: FlashcardSet
    @StateObject private var viewModel: FlashcardSessionViewModel
    @Environment(\.dismiss) var dismiss
    
    init(set: FlashcardSet) {
        self.set = set
        _viewModel = StateObject(wrappedValue: FlashcardSessionViewModel(set: set))
    }
    
    var body: some View {
        Group {
            if set.cards.isEmpty {
                EmptyStateView(
                    icon: "exclamationmark.triangle",
                    title: "Набор пуст",
                    message: "В этом наборе нет карточек для обучения",
                    actionTitle: "Закрыть",
                    action: { dismiss() }
                )
            } else {
                VStack(spacing: AppConstants.Spacing.large) {
                    // Прогресс
                    VStack(spacing: AppConstants.Spacing.small) {
                        ProgressBar(progress: viewModel.progress)
                        
                        HStack {
                            Text("\(viewModel.currentCardIndex + 1) / \(set.cards.count)")
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(viewModel.remainingCards) осталось")
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Карточка
                    if let card = viewModel.currentCard {
                        FlashcardView(
                            card: card,
                            isFlipped: $viewModel.isFlipped,
                            showAnswer: $viewModel.showAnswer,
                            onFlip: {
                                viewModel.flipCard()
                                if !viewModel.showAnswer {
                                    viewModel.showAnswer = true
                                }
                            },
                            onKnow: {
                                viewModel.markAsKnown()
                            },
                            onDontKnow: {
                                viewModel.markAsUnknown()
                            }
                        )
                    }
                    
                    Spacer()
                }
                .navigationTitle("Карточки")
                .navigationBarTitleDisplayMode(.inline)
                .background(AppConstants.Colors.bridgyBackground)
                .alert("Сессия завершена!", isPresented: $viewModel.isSessionComplete) {
                    Button("Готово") {
                        dismiss()
                    }
                } message: {
                    Text("Вы изучили \(set.cards.count) карточек\nПравильно: \(viewModel.correctCount)\nНеправильно: \(viewModel.incorrectCount)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlashcardLearningView(set: FlashcardSet.mock)
    }
}

