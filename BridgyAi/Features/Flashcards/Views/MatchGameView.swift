//
//  MatchGameView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct MatchGameView: View {
    let set: FlashcardSet
    @StateObject private var viewModel: MatchGameViewModel
    @Environment(\.dismiss) var dismiss
    
    init(set: FlashcardSet) {
        self.set = set
        _viewModel = StateObject(wrappedValue: MatchGameViewModel(set: set))
    }
    
    var body: some View {
        Group {
            if set.cards.isEmpty {
                EmptyStateView(
                    icon: "exclamationmark.triangle",
                    title: "Набор пуст",
                    message: "В этом наборе нет карточек для игры",
                    actionTitle: "Закрыть",
                    action: { dismiss() }
                )
            } else {
                VStack {
                    // Хедер с таймером и счетом
                    GameHeaderView(
                        timeRemaining: viewModel.timeRemaining,
                        score: viewModel.score,
                        matchesFound: viewModel.matchesFound,
                        totalMatches: viewModel.totalMatches
                    )
                    
                    // Игровое поле
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ForEach(viewModel.tiles) { tile in
                                MatchTileView(
                                    tile: tile,
                                    onTap: {
                                        viewModel.selectTile(tile)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    
                    // Кнопка рестарта
                    SecondaryButton("Начать заново", icon: "arrow.clockwise") {
                        viewModel.restartGame()
                    }
                    .padding()
                }
                .navigationTitle("Игра на сопоставление")
                .navigationBarTitleDisplayMode(.inline)
                .background(AppConstants.Colors.bridgyBackground)
                .onAppear {
                    viewModel.startGame()
                }
                .alert("Игра окончена!", isPresented: $viewModel.isGameOver) {
                    Button("Играть снова") {
                        viewModel.restartGame()
                    }
                    Button("Завершить") {
                        dismiss()
                    }
                } message: {
                    Text("Ваш счет: \(viewModel.score)\nСопоставлений: \(viewModel.matchesFound)/\(viewModel.totalMatches)\nВремя: \(AppFormatters.formatDuration(TimeInterval(viewModel.timeRemaining)))")
                }
            }
        }
    }
}

struct GameHeaderView: View {
    let timeRemaining: Int
    let score: Int
    let matchesFound: Int
    let totalMatches: Int
    
    var body: some View {
        CardView {
            HStack {
                VStack(alignment: .leading) {
                    Text("Score: \(score)")
                        .font(AppConstants.Fonts.headline)
                    
                    Text("Matches: \(matchesFound)/\(totalMatches)")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "timer")
                        Text(AppFormatters.formatDuration(TimeInterval(timeRemaining)))
                    }
                    .font(AppConstants.Fonts.headline)
                    .foregroundColor(timeRemaining < 30 ? AppConstants.Colors.bridgyError : AppConstants.Colors.bridgyText)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MatchTileView: View {
    let tile: MatchTile
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .fill(tile.isMatched ? AppConstants.Colors.bridgySuccess.opacity(0.3) : AppConstants.Colors.bridgyCard)
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                            .stroke(
                                tile.isMatched
                                    ? AppConstants.Colors.bridgySuccess
                                    : tile.isFlipped
                                        ? AppConstants.Colors.bridgyPrimary
                                        : Color.gray.opacity(0.3),
                                lineWidth: tile.isFlipped || tile.isMatched ? 2 : 1
                            )
                    )
                
                if tile.isFlipped || tile.isMatched {
                    Text(tile.content)
                        .font(AppConstants.Fonts.caption)
                        .multilineTextAlignment(.center)
                        .padding(4)
                        .foregroundColor(AppConstants.Colors.bridgyText)
                } else {
                    Image(systemName: "questionmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
        }
        .disabled(tile.isMatched)
    }
}

#Preview {
    NavigationStack {
        MatchGameView(set: FlashcardSet.mock)
    }
}

