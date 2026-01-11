//
//  SpeakModeView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI
import Combine

struct SpeakModeView: View {
    let set: FlashcardSet
    @StateObject private var viewModel: LearningModeViewModel
    private var speechService: SpeechServiceProtocol {
        AppDependencies.shared.speechService
    }
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var currentCancellable: AnyCancellable?
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    
    init(set: FlashcardSet) {
        self.set = set
        _viewModel = StateObject(wrappedValue: LearningModeViewModel(set: set, mode: .speak))
    }
    
    var body: some View {
        Group {
            if set.cards.isEmpty {
                EmptyStateView(
                    icon: "exclamationmark.triangle",
                    title: "Набор пуст",
                    message: "В этом наборе нет карточек для обучения произношению",
                    actionTitle: "Закрыть",
                    action: { dismiss() }
                )
            } else {
                VStack(spacing: 20) {
                    // Прогресс
                    VStack(spacing: AppConstants.Spacing.small) {
                        ProgressBar(progress: viewModel.progress)
                        
                        HStack {
                            Text("\(viewModel.currentCardIndex + 1) / \(set.cards.count)")
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Текущая карточка
                    if let currentCard = viewModel.currentCard {
                VStack(spacing: 16) {
                    CardView {
                        VStack(spacing: AppConstants.Spacing.medium) {
                            Text(currentCard.back)
                                .font(AppConstants.Fonts.title)
                                .multilineTextAlignment(.center)
                            
                            if let phonetic = currentCard.phonetic {
                                Text(phonetic)
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    }
                    
                    // Кнопка прослушивания
                    Button(action: {
                        _ = speechService.speak(currentCard.back)
                    }) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Прослушать")
                        }
                        .font(AppConstants.Fonts.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppConstants.Colors.bridgyPrimary)
                        .cornerRadius(AppConstants.CornerRadius.medium)
                    }
                    
                    // Кнопка записи
                    Button(action: {
                        if isRecording {
                            speechService.stopListening()
                            currentCancellable?.cancel()
                            currentCancellable = nil
                            isRecording = false
                        } else {
                            isRecording = true
                            currentCancellable = speechService.startListening()
                                .receive(on: DispatchQueue.main)
                                .sink(
                                    receiveCompletion: { completion in
                                        isRecording = false
                                        if case .failure(let error) = completion {
                                            print("Speech recognition error: \(error)")
                                            // Показываем сообщение об ошибке пользователю
                                            if let speechError = error as? SpeechServiceError {
                                                switch speechError {
                                                case .authorizationDenied:
                                                    errorMessage = "Разрешение на микрофон или распознавание речи не предоставлено. Пожалуйста, предоставьте разрешения в настройках."
                                                case .recognizerUnavailable:
                                                    errorMessage = "Распознавание речи недоступно. Проверьте подключение к интернету."
                                                default:
                                                    errorMessage = "Ошибка распознавания речи"
                                                }
                                            } else {
                                                errorMessage = "Ошибка: \(error.localizedDescription)"
                                            }
                                        }
                                    },
                                    receiveValue: { text in
                                        transcribedText = text
                                        viewModel.checkAnswer(text)
                                        isRecording = false
                                    }
                                )
                        }
                    }) {
                        HStack {
                            Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill")
                            Text(isRecording ? "Остановить запись" : "Начать запись")
                        }
                        .font(AppConstants.Fonts.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRecording ? AppConstants.Colors.bridgyError : AppConstants.Colors.bridgySecondary)
                        .cornerRadius(AppConstants.CornerRadius.medium)
                    }
                    
                    if !transcribedText.isEmpty {
                        Text("Вы сказали: \(transcribedText)")
                            .font(AppConstants.Fonts.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(AppConstants.CornerRadius.medium)
                    }
                    
                    if let errorMessage = errorMessage {
                        CardView {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(AppConstants.Colors.bridgyError)
                                Text(errorMessage)
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(AppConstants.Colors.bridgyError)
                                Spacer()
                                Button(action: {
                                    self.errorMessage = nil
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            
            // Результат
            if let result = viewModel.lastResult {
                CardView {
                    HStack {
                        Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(result.isCorrect ? AppConstants.Colors.bridgySuccess : AppConstants.Colors.bridgyError)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(result.isCorrect ? "Отличное произношение!" : "Попробуйте еще раз")
                                .font(AppConstants.Fonts.headline)
                            
                            if !result.isCorrect {
                                Text("Ожидалось: \(result.correctAnswer)")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Кнопка следующей карточки
            if viewModel.lastResult != nil {
                PrimaryButton("Следующая карточка", icon: "arrow.right") {
                    viewModel.nextCard()
                    transcribedText = ""
                    errorMessage = nil
                }
                .padding(.horizontal)
            }
        }
                    .navigationTitle("Режим произношения")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(AppConstants.Colors.bridgyBackground)
                    .onDisappear {
                        // Останавливаем запись при закрытии экрана
                        if isRecording {
                            speechService.stopListening()
                            currentCancellable?.cancel()
                        }
                    }
                    .alert("Сессия завершена!", isPresented: $viewModel.isSessionComplete) {
                        Button("Готово") {
                            dismiss()
                        }
                    } message: {
                        Text("Вы отработали \(set.cards.count) карточек\nПравильно: \(viewModel.correctCount)")
                    }
                }
            }
        }
    }


#Preview {
    NavigationStack {
        SpeakModeView(set: FlashcardSet.mock)
    }
}

