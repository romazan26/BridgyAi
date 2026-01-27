//
//  NotificationsListView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct NotificationsListView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NotificationRow(
                        icon: "bell.fill",
                        title: "Время учить английский!",
                        message: "Вы получили новое напоминание об изучении",
                        time: "2 часа назад",
                        isRead: false
                    )
                    
                    NotificationRow(
                        icon: "star.fill",
                        title: "Новое достижение!",
                        message: "Вы изучили 50 карточек",
                        time: "Вчера",
                        isRead: true
                    )
                    
                    NotificationRow(
                        icon: "flame.fill",
                        title: "Отличная серия!",
                        message: "Вы учитесь уже 7 дней подряд",
                        time: "2 дня назад",
                        isRead: true
                    )
                } header: {
                    Text("Уведомления")
                }
            }
            .navigationTitle("Уведомления")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NotificationRow: View {
    let icon: String
    let title: String
    let message: String
    let time: String
    let isRead: Bool
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.medium) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppConstants.Colors.bridgyPrimary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppConstants.Fonts.headline)
                    .foregroundColor(isRead ? .secondary : .primary)
                
                Text(message)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if !isRead {
                    Circle()
                        .fill(AppConstants.Colors.bridgyPrimary)
                        .frame(width: 8, height: 8)
                }
                
                Text(time)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotificationsListView()
}
