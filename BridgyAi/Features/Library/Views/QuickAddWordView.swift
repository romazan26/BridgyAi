//
//  QuickAddWordView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct QuickAddWordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = QuickAddWordViewModel()
    @FocusState private var isFrontFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Слово или фраза") {
                    TextField("Английский текст", text: $viewModel.front)
                        .focused($isFrontFocused)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                Section("Перевод или значение") {
                    TextField("Русский перевод", text: $viewModel.back)
                        .autocapitalization(.sentences)
                }
                
                Section("Дополнительно (необязательно)") {
                    TextField("Пример использования", text: $viewModel.example, axis: .vertical)
                        .lineLimit(2...4)
                    
                    TextField("Подсказка", text: $viewModel.hint)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Section {
                        Text(viewModel.errorMessage)
                            .foregroundColor(AppConstants.Colors.bridgyError)
                            .font(AppConstants.Fonts.caption)
                    }
                }
            }
            .navigationTitle("Добавить слово")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Добавить") {
                        viewModel.saveWord {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .onAppear {
                isFrontFocused = true
            }
        }
    }
}

#Preview {
    QuickAddWordView()
}
