//
//  CreateSetView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

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

#Preview {
    CreateSetView()
}

