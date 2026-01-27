//
//  CardEditRow.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

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

#Preview {
    Form {
        CardEditRow(card: .constant(CardDraft(front: "Test", back: "Тест"))) {
            print("Delete")
        }
    }
}
