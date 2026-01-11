//
//  TestModeView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct TestModeView: View {
    let set: FlashcardSet
    @StateObject private var viewModel: LearningModeViewModel
    @State private var selectedAnswer: String?
    @Environment(\.dismiss) var dismiss
    
    init(set: FlashcardSet) {
        self.set = set
        _viewModel = StateObject(wrappedValue: LearningModeViewModel(set: set, mode: .test))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Прогресс
            VStack(spacing: AppConstants.Spacing.small) {
                ProgressBar(progress: viewModel.progress)
                
                HStack {
                    Text("\(viewModel.currentCardIndex + 1) / \(set.cards.count)")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Score: \(viewModel.correctCount)")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(AppConstants.Colors.bridgySuccess)
                }
            }
            .padding(.horizontal)
            
            // Текущая карточка
            if let currentCard = viewModel.currentCard {
                VStack(spacing: 16) {
                    CardView {
                        Text(currentCard.front)
                            .font(AppConstants.Fonts.title)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Варианты ответов
                    VStack(spacing: AppConstants.Spacing.medium) {
                        ForEach(generateOptions(for: currentCard), id: \.self) { option in
                            AnswerOptionButton(
                                text: option,
                                isSelected: selectedAnswer == option,
                                isCorrect: viewModel.lastResult != nil && option == currentCard.back,
                                isIncorrect: viewModel.lastResult != nil && selectedAnswer == option && option != currentCard.back,
                                action: {
                                    if viewModel.lastResult == nil {
                                        selectedAnswer = option
                                        viewModel.checkAnswer(option)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Кнопка следующей карточки
            if viewModel.lastResult != nil {
                PrimaryButton("Next Question", icon: "arrow.right") {
                    viewModel.nextCard()
                    selectedAnswer = nil
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Test Mode")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppConstants.Colors.bridgyBackground)
        .alert("Session Complete!", isPresented: $viewModel.isSessionComplete) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("You completed \(set.cards.count) questions\nCorrect: \(viewModel.correctCount)\nIncorrect: \(viewModel.incorrectCount)")
        }
    }
    
    private func generateOptions(for card: Flashcard) -> [String] {
        var options = [card.back]
        
        // Добавляем случайные варианты из других карточек
        let otherCards = set.cards.filter { $0.id != card.id }.shuffled().prefix(3)
        options.append(contentsOf: otherCards.map { $0.back })
        
        return options.shuffled()
    }
}

struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isIncorrect: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(AppConstants.Fonts.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppConstants.Colors.bridgySuccess)
                } else if isIncorrect {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppConstants.Colors.bridgyError)
                }
            }
            .padding()
            .background(
                isCorrect
                    ? AppConstants.Colors.bridgySuccess.opacity(0.2)
                    : isIncorrect
                        ? AppConstants.Colors.bridgyError.opacity(0.2)
                        : isSelected
                            ? AppConstants.Colors.bridgyPrimary.opacity(0.1)
                            : Color(.systemGray6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .stroke(
                        isCorrect
                            ? AppConstants.Colors.bridgySuccess
                            : isIncorrect
                                ? AppConstants.Colors.bridgyError
                                : isSelected
                                    ? AppConstants.Colors.bridgyPrimary
                                    : Color.clear,
                        lineWidth: 2
                    )
            )
            .cornerRadius(AppConstants.CornerRadius.medium)
        }
        .disabled(isCorrect || isIncorrect)
    }
}

#Preview {
    NavigationStack {
        TestModeView(set: FlashcardSet.mock)
    }
}


