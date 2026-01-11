//
//  WriteModeView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct WriteModeView: View {
    let set: FlashcardSet
    @StateObject private var viewModel: LearningModeViewModel
    @State private var userInput = ""
    @FocusState private var isInputFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    init(set: FlashcardSet) {
        self.set = set
        _viewModel = StateObject(wrappedValue: LearningModeViewModel(set: set, mode: .write))
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
                    
                    // Поле ввода
                    TextField("Type the phrase...", text: $userInput)
                        .focused($isInputFocused)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Spacer()
                                if !userInput.isEmpty {
                                    Button {
                                        userInput = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )
                    
                    // Кнопка проверки
                    PrimaryButton("Check Answer", icon: "checkmark.circle.fill", isEnabled: !userInput.isEmpty) {
                        viewModel.checkAnswer(userInput)
                        userInput = ""
                    }
                }
                .padding()
            }
            
            // Результат предыдущей попытки
            if let result = viewModel.lastResult {
                CardView {
                    HStack {
                        Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(result.isCorrect ? AppConstants.Colors.bridgySuccess : AppConstants.Colors.bridgyError)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(result.isCorrect ? "Correct!" : "Incorrect")
                                .font(AppConstants.Fonts.headline)
                            
                            if !result.isCorrect, let correctAnswer = result.correctAnswer as String? {
                                Text("Correct: \(correctAnswer)")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .transition(.slide)
            }
            
            Spacer()
            
            // Кнопка следующей карточки
            if viewModel.lastResult != nil {
                PrimaryButton("Next Card", icon: "arrow.right") {
                    viewModel.nextCard()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Write Mode")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppConstants.Colors.bridgyBackground)
        .onAppear {
            isInputFocused = true
        }
        .alert("Session Complete!", isPresented: $viewModel.isSessionComplete) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("You completed \(set.cards.count) cards\nCorrect: \(viewModel.correctCount)\nIncorrect: \(viewModel.incorrectCount)")
        }
    }
}

#Preview {
    NavigationStack {
        WriteModeView(set: FlashcardSet.mock)
    }
}


