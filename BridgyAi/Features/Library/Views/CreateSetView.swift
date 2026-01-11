//
//  CreateSetView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI
import Combine

struct CreateSetView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CreateSetViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основная информация") {
                    TextField("Название набора", text: $viewModel.title)
                    TextField("Описание", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Параметры") {
                    Picker("Сценарий", selection: $viewModel.selectedScenario) {
                        ForEach(WorkScenario.allCases, id: \.self) { scenario in
                            HStack {
                                Image(systemName: scenario.icon)
                                Text(scenario.title)
                            }
                            .tag(scenario)
                        }
                    }
                    
                    Picker("Уровень сложности", selection: $viewModel.selectedDifficulty) {
                        ForEach(DifficultyLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }
                
                Section("Карточки") {
                    ForEach(viewModel.cards.indices, id: \.self) { index in
                        CardEditRow(
                            card: $viewModel.cards[index],
                            onDelete: {
                                viewModel.cards.remove(at: index)
                            }
                        )
                    }
                    
                    Button(action: {
                        viewModel.addCard()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Добавить карточку")
                        }
                    }
                }
            }
            .navigationTitle("Создать набор")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        viewModel.saveSet()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

struct CardEditRow: View {
    @Binding var card: CardDraft
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Вопрос/Контекст", text: $card.front)
            TextField("Ответ/Перевод", text: $card.back)
            
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct CardDraft {
    var front: String = ""
    var back: String = ""
}

class CreateSetViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedScenario: WorkScenario = .meetings
    @Published var selectedDifficulty: DifficultyLevel = .beginner
    @Published var cards: [CardDraft] = [CardDraft()]
    
    private let dataService: DataServiceProtocol = AppDependencies.shared.dataService
    
    var isValid: Bool {
        !title.isEmpty && !description.isEmpty && cards.allSatisfy { !$0.front.isEmpty && !$0.back.isEmpty }
    }
    
    func addCard() {
        cards.append(CardDraft())
    }
    
    func saveSet() {
        let flashcards = cards.map { draft in
            Flashcard(
                id: UUID().uuidString,
                front: draft.front,
                back: draft.back,
                phonetic: nil,
                example: nil,
                hint: nil,
                audioURL: nil,
                imageURL: nil,
                tags: []
            )
        }
        
        let set = FlashcardSet(
            id: UUID().uuidString,
            title: title,
            description: description,
            workScenario: selectedScenario,
            difficulty: selectedDifficulty,
            cards: flashcards,
            author: nil,
            isPremium: false,
            averageStudyTime: flashcards.count * 2,
            totalTerms: flashcards.count,
            createdAt: Date(),
            lastStudied: nil,
            masteryLevel: 0.0,
            isFavorite: false
        )
        
        _ = dataService.saveSet(set)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error saving set: \(error)")
                    }
                },
                receiveValue: { _ in }
            )
    }
}

#Preview {
    CreateSetView()
}

