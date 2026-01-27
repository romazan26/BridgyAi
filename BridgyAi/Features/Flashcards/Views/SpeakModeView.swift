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
                        errorMessage = nil // Очищаем предыдущие ошибки
                        let cancellable = speechService.speak(currentCard.back)
                            .receive(on: DispatchQueue.main)
                            .sink(
                                receiveCompletion: { completion in
                                    if case .failure(let error) = completion {
                                        print("Speech synthesis error: \(error)")
                                        // Показываем ошибку только если это не просто отмена предыдущего синтеза
                                        if let speechError = error as? SpeechServiceError,
                                           speechError == .synthesizerUnavailable {
                                            // Это может быть отмена предыдущего синтеза, не показываем ошибку
                                            return
                                        }
                                        errorMessage = "Ошибка воспроизведения. Попробуйте еще раз."
                                    }
                                },
                                receiveValue: { }
                            )
                        // Сохраняем cancellable, чтобы не отменять сразу
                        _ = cancellable
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
                            // Останавливаем запись
                            // stopListening() вызовет promise, который завершит publisher автоматически
                            speechService.stopListening()
                            // Не отменяем cancellable здесь - пусть publisher завершится естественным образом через promise
                            // cancellable будет очищен автоматически когда publisher завершится
                            isRecording = false
                        } else {
                            // Начинаем запись
                            transcribedText = "" // Очищаем предыдущий текст
                            errorMessage = nil // Очищаем ошибки
                            isRecording = true
                            
                            currentCancellable = speechService.startListening()
                                .receive(on: DispatchQueue.main)
                                .handleEvents(receiveCancel: {
                                    print("⚠️ Publisher был отменен")
                                })
                                .sink(
                                    receiveCompletion: { completion in
                                        print("📦 receiveCompletion вызван: \(completion)")
                                        isRecording = false
                                        
                                        // Очищаем cancellable при завершении
                                        currentCancellable = nil
                                        
                                        // Если транскрипт уже получен, не показываем ошибку отмены
                                        if !transcribedText.isEmpty {
                                            print("✅ Транскрипт уже получен, игнорируем ошибку завершения")
                                            return
                                        }
                                        
                                        if case .failure(let error) = completion {
                                            print("❌ Speech recognition error: \(error)")
                                            
                                            // Игнорируем ошибку 216 (отмена) - это нормально при ручной остановке
                                            let nsError = error as NSError
                                            if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 216 {
                                                print("ℹ️ Игнорируем ошибку отмены (216)")
                                                return
                                            }
                                            
                                            // Показываем сообщение об ошибке пользователю только для реальных ошибок
                                            if let speechError = error as? SpeechServiceError {
                                                switch speechError {
                                                case .authorizationDenied:
                                                    errorMessage = "Разрешение на микрофон или распознавание речи не предоставлено. Пожалуйста, предоставьте разрешения в настройках."
                                                case .recognizerUnavailable:
                                                    errorMessage = "Распознавание речи недоступно. Проверьте подключение к интернету или попробуйте еще раз."
                                                default:
                                                    errorMessage = "Ошибка распознавания речи"
                                                }
                                            } else {
                                                errorMessage = "Ошибка: \(error.localizedDescription)"
                                            }
                                        }
                                    },
                                    receiveValue: { text in
                                        print("🎯 ===== receiveValue ВЫЗВАН ===== ")
                                        print("✅ Распознанный текст получен в receiveValue: '\(text)'")
                                        print("📊 Текущее состояние: isRecording=\(isRecording), transcribedText='\(transcribedText)'")
                                        
                                        // Устанавливаем транскрипт в состояние (уже на главном потоке благодаря receive(on:))
                                        print("🔄 Устанавливаем transcribedText: '\(text)'")
                                        transcribedText = text
                                        print("✅ transcribedText установлен: '\(transcribedText)'")
                                        
                                        if let currentCard = viewModel.currentCard {
                                            print("📝 Оригинальный текст: '\(currentCard.back)'")
                                            let isMatch = text.fuzzyMatch(currentCard.back)
                                            print("🔍 Сравнение: \(isMatch)")
                                            
                                            // Автоматически проверяем ответ
                                            viewModel.checkAnswer(text)
                                            print("✅ Ответ проверен, lastResult: \(viewModel.lastResult != nil ? "есть" : "нет")")
                                            if let result = viewModel.lastResult {
                                                print("📊 Результат: правильный=\(result.isCorrect), ваш ответ='\(result.userAnswer)', правильный='\(result.correctAnswer)'")
                                            }
                                        }
                                        
                                        isRecording = false
                                        print("🎯 ===== receiveValue ЗАВЕРШЕН ===== ")
                                    }
                                )
                        }
                    }) {
                        HStack {
                            if isRecording {
                                // Анимированный индикатор записи
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                    .opacity(isRecording ? 0.5 : 1.0)
                                    .scaleEffect(isRecording ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isRecording)
                            }
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
                    
                    // Отображение транскрибированного текста
                    if !transcribedText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "waveform")
                                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                Text("Вы сказали:")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(transcribedText)
                                .font(AppConstants.Fonts.headline)
                                .foregroundColor(AppConstants.Colors.bridgyText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                        .fill(AppConstants.Colors.bridgyCard)
                                )
                            
                            if let currentCard = viewModel.currentCard {
                                HStack {
                                    Image(systemName: "text.book.closed")
                                        .foregroundColor(AppConstants.Colors.bridgySecondary)
                                    Text("Оригинал: \(currentCard.back)")
                                        .font(AppConstants.Fonts.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                .fill(AppConstants.Colors.bridgyBackground.opacity(0.5))
                        )
                        .transition(.scale.combined(with: .opacity))
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
            
            // Результат сравнения
            if let result = viewModel.lastResult {
                CardView(hasGradient: result.isCorrect) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.isCorrect ? AppConstants.Colors.bridgySuccess : AppConstants.Colors.bridgyError)
                                .font(.title2)
                            
                            Text(result.isCorrect ? "Отличное произношение!" : "Попробуйте еще раз")
                                .font(AppConstants.Fonts.headline)
                                .foregroundColor(result.isCorrect ? AppConstants.Colors.bridgySuccess : AppConstants.Colors.bridgyError)
                            
                            Spacer()
                        }
                        
                        if !result.isCorrect {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ваш ответ:")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                                Text(result.userAnswer)
                                    .font(AppConstants.Fonts.body)
                                    .foregroundColor(AppConstants.Colors.bridgyText)
                                
                                Text("Правильный ответ:")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                                Text(result.correctAnswer)
                                    .font(AppConstants.Fonts.body)
                                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                    .fontWeight(.semibold)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding()
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

