//
//  RecentActivityView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct RecentActivityView: View {
    let sessions: [LearningSession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Недавняя активность")
                .font(AppConstants.Fonts.headline)
                .padding(.horizontal)
            
            if sessions.isEmpty {
                EmptyStateView(
                    icon: "clock",
                    title: "Нет недавней активности",
                    message: "Начните обучение, чтобы увидеть свой прогресс здесь"
                )
                .frame(height: 150)
            } else {
                ForEach(sessions) { session in
                    ActivityRowView(session: session)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ActivityRowView: View {
    let session: LearningSession
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.bridgyPrimary.opacity(0.2),
                                AppConstants.Colors.bridgySecondary.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: session.mode.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(session.mode.title)
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(AppConstants.Colors.bridgyText)
                
                HStack(spacing: 8) {
                    Label("\(session.cardsStudied)", systemImage: "rectangle.stack")
                    Text("•")
                    Label(AppFormatters.formatDuration(session.duration), systemImage: "clock")
                }
                .font(AppConstants.Fonts.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(session.startTime.formatted(style: .short))
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(AppConstants.Colors.bridgyCard)
        .cornerRadius(AppConstants.CornerRadius.medium)
        .shadow(color: AppConstants.Shadows.small, radius: 4, x: 0, y: 2)
    }
}

struct NotificationButton: View {
    let count: Int
    
    var body: some View {
        Button(action: {}) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .foregroundColor(AppConstants.Colors.bridgyText)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(AppConstants.Colors.bridgyError)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}

#Preview {
    VStack {
        RecentActivityView(sessions: [])
        RecentActivityView(sessions: [LearningSession.mock])
    }
    .padding()
}
