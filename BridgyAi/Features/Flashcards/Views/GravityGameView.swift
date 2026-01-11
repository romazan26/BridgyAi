//
//  GravityGameView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct GravityGameView: View {
    let set: FlashcardSet
    @StateObject private var viewModel: LearningModeViewModel
    @State private var userInput = ""
    @FocusState private var isInputFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    init(set: FlashcardSet) {
        self.set = set
        _viewModel = StateObject(wrappedValue: LearningModeViewModel(set: set, mode: .gravity))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Хедер с прогрессом
            HStack {
                Text("Score: \(viewModel.correctCount)")
                    .font(AppConstants.Fonts.headline)
                
                Spacer()
                
                Text("\(viewModel.currentCardIndex + 1) / \(set.cards.count)")
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Текущая карточка (падающая)
            if let currentCard = viewModel.currentCard {
                VStack(spacing: 16) {
                    CardView {
                        Text(currentCard.front)
                            .font(AppConstants.Fonts.title)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    // Поле ввода
                    TextField("Type quickly...", text: $userInput)
                        .focused($isInputFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppConstants.Colors.bridgyPrimary, lineWidth: 2)
                        )
                        .padding(.horizontal)
                        .onChange(of: userInput) { newValue in
                            if newValue.fuzzyMatch(currentCard.back) {
                                viewModel.checkAnswer(newValue)
                                userInput = ""
                                viewModel.nextCard()
                            }
                        }
                }
            }
            
            Spacer()
            
            // Результат
            if let result = viewModel.lastResult {
                HStack {
                    Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(result.isCorrect ? AppConstants.Colors.bridgySuccess : AppConstants.Colors.bridgyError)
                        .font(.title2)
                    
                    Text(result.isCorrect ? "Correct!" : "Missed!")
                        .font(AppConstants.Fonts.headline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(AppConstants.CornerRadius.medium)
                .padding(.horizontal)
                .transition(.scale)
            }
        }
        .navigationTitle("Gravity")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppConstants.Colors.bridgyBackground)
        .onAppear {
            isInputFocused = true
        }
        .alert("Game Over!", isPresented: $viewModel.isSessionComplete) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("You typed \(viewModel.correctCount) cards correctly!")
        }
    }
}

#Preview {
    NavigationStack {
        GravityGameView(set: FlashcardSet.mock)
    }
}


