//
//  SubscriptionView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        ZStack {
            // Анимированный фон
            AnimatedBackground()
            
            ScrollView {
            VStack(spacing: AppConstants.Spacing.xLarge) {
                Spacer()
                    .frame(height: 40)
                
                // Иконка с градиентом
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppConstants.Colors.bridgyPrimary.opacity(0.2),
                                    AppConstants.Colors.bridgySecondary.opacity(0.15)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppConstants.Colors.bridgyPrimary,
                                    AppConstants.Colors.bridgySecondary
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: AppConstants.Colors.bridgyPrimary.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(spacing: AppConstants.Spacing.medium) {
                    Text("Скоро здесь!")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(AppConstants.Colors.bridgyText)
                    
                    Text("В скором времени здесь можно будет приобрести много нового учебного контента")
                        .font(AppConstants.Fonts.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, AppConstants.Spacing.large)
                }
                
                // Карточка с преимуществами
                CardView(hasGradient: true) {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Что вас ждет:")
                            .font(AppConstants.Fonts.headline)
                            .foregroundColor(AppConstants.Colors.bridgyText)
                        
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                            FeatureRow(icon: "sparkles", text: "Расширенная библиотека наборов")
                            FeatureRow(icon: "brain.head.profile", text: "AI-репетитор для персонального обучения")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Детальная аналитика прогресса")
                            FeatureRow(icon: "person.2.fill", text: "Синхронизация на всех устройствах")
                            FeatureRow(icon: "star.fill", text: "Эксклюзивный контент от экспертов")
                        }
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.large)
                
                Spacer()
                    .frame(height: 40)
                }
            }
        }
        .navigationTitle("Подписка")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.bridgyPrimary.opacity(0.15),
                                AppConstants.Colors.bridgySecondary.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
            }
            
            Text(text)
                .font(AppConstants.Fonts.body)
                .foregroundColor(AppConstants.Colors.bridgyText)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionView()
    }
}
