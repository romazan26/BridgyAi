//
//  FlashcardView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct FlashcardView: View {
    let card: Flashcard
    @Binding var isFlipped: Bool
    @Binding var showAnswer: Bool
    let onFlip: () -> Void
    let onKnow: () -> Void
    let onDontKnow: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Карточка
            ZStack {
                // Лицевая сторона
                CardFrontView(
                    content: card.front,
                    hint: card.hint,
                    isFlipped: isFlipped
                )
                
                // Обратная сторона
                CardBackView(
                    content: card.back,
                    phonetic: card.phonetic,
                    example: card.example,
                    isFlipped: isFlipped
                )
            }
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isFlipped)
            .onTapGesture { onFlip() }
            
            // Контролы
            if showAnswer {
                HStack(spacing: 16) {
                    ActionButton(
                        title: "Не знал",
                        icon: "xmark.circle.fill",
                        color: AppConstants.Colors.bridgyError,
                        action: onDontKnow
                    )
                    
                    ActionButton(
                        title: "Знаю",
                        icon: "checkmark.circle.fill",
                        color: AppConstants.Colors.bridgySuccess,
                        action: onKnow
                    )
                }
                .transition(.scale.combined(with: .opacity))
            } else {
                PrimaryButton("Показать ответ", icon: "eye.fill") {
                    withAnimation {
                        showAnswer = true
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding()
    }
}

struct CardFrontView: View {
    let content: String
    let hint: String?
    let isFlipped: Bool
    
    var body: some View {
        ZStack {
            // Светлый градиентный фон для лицевой стороны
            LinearGradient(
                gradient: Gradient(colors: [
                    AppConstants.Colors.bridgyCard,
                    AppConstants.Colors.bridgyBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: AppConstants.Spacing.large) {
                // Иконка вопроса
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppConstants.Colors.bridgyPrimary.opacity(0.3))
                    .padding(.top, AppConstants.Spacing.medium)
                
                Text(content)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(AppConstants.Colors.bridgyText)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let hint = hint, !isFlipped {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(AppConstants.Colors.bridgyWarning)
                        Text(hint)
                            .font(AppConstants.Fonts.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                    .padding(.horizontal, AppConstants.Spacing.medium)
                    .padding(.vertical, AppConstants.Spacing.small)
                    .background(
                        Capsule()
                            .fill(AppConstants.Colors.bridgyWarning.opacity(0.1))
                    )
                }
                
                Spacer()
                    .frame(height: AppConstants.Spacing.medium)
            }
            .padding(AppConstants.Spacing.large)
        }
        .cornerRadius(AppConstants.CornerRadius.large)
        .shadow(color: AppConstants.Shadows.medium, radius: 10, x: 0, y: 4)
        .opacity(isFlipped ? 0 : 1)
        .allowsHitTesting(!isFlipped)
    }
}

struct CardBackView: View {
    let content: String
    let phonetic: String?
    let example: String?
    let isFlipped: Bool
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [
                    AppConstants.Colors.bridgyPrimary.opacity(0.1),
                    AppConstants.Colors.bridgySecondary.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.large) {
                    // Основной ответ
                    VStack(spacing: AppConstants.Spacing.small) {
                        Text(content)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppConstants.Colors.bridgyPrimary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, AppConstants.Spacing.medium)
                    }
                    
                    // Фонетика
                    if let phonetic = phonetic {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "waveform")
                                    .font(.title3)
                                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                Text("Произношение")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(phonetic)
                                .font(.system(size: 16, design: .monospaced))
                                .foregroundColor(AppConstants.Colors.bridgyText)
                                .lineLimit(nil)
                                .padding(.leading, 32)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                .fill(AppConstants.Colors.bridgyCard)
                                .shadow(color: AppConstants.Shadows.small, radius: 2, x: 0, y: 1)
                        )
                    }
                    
                    // Пример
                    if let example = example {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "quote.bubble.fill")
                                    .font(.title3)
                                    .foregroundColor(AppConstants.Colors.bridgySecondary)
                                Text("Пример")
                                    .font(AppConstants.Fonts.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(example)
                                .font(AppConstants.Fonts.body)
                                .foregroundColor(AppConstants.Colors.bridgyText)
                                .italic()
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                                .padding(.leading, 32)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                                .fill(AppConstants.Colors.bridgyCard)
                                .shadow(color: AppConstants.Shadows.small, radius: 2, x: 0, y: 1)
                        )
                    }
                }
                .padding(AppConstants.Spacing.large)
            }
        }
        .cornerRadius(AppConstants.CornerRadius.large)
        .shadow(color: AppConstants.Shadows.medium, radius: 10, x: 0, y: 4)
        .frame(maxHeight: 500)
        .opacity(isFlipped ? 1 : 0)
        .scaleEffect(isFlipped ? 1 : 0.8)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .allowsHitTesting(isFlipped)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(AppConstants.Fonts.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppConstants.Spacing.medium)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppConstants.CornerRadius.medium)
            .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FlashcardView(
        card: Flashcard.mock,
        isFlipped: .constant(false),
        showAnswer: .constant(false),
        onFlip: {},
        onKnow: {},
        onDontKnow: {}
    )
}


