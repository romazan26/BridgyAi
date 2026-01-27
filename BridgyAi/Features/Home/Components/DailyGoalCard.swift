//
//  DailyGoalCard.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct DailyGoalCard: View {
    let progress: Double
    let streak: Int
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        CardView(hasGradient: true) {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ежедневная цель")
                            .font(AppConstants.Fonts.headline)
                            .foregroundColor(AppConstants.Colors.bridgyText)
                        
                        Text("Продолжайте в том же духе!")
                            .font(AppConstants.Fonts.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Streak badge с градиентом
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppConstants.Colors.bridgyWarning,
                                        Color.orange
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("\(streak)")
                            .font(AppConstants.Fonts.headline)
                            .foregroundColor(AppConstants.Colors.bridgyText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppConstants.Colors.bridgyWarning.opacity(0.15),
                                        Color.orange.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                }
                
                ProgressBar(progress: animatedProgress)
                
                HStack {
                    Text("\(Int(animatedProgress * 100))% выполнено")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if animatedProgress >= 1.0 {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppConstants.Colors.bridgySuccess)
                            Text("Цель достигнута!")
                                .font(AppConstants.Fonts.caption)
                                .foregroundColor(AppConstants.Colors.bridgySuccess)
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    DailyGoalCard(progress: 0.6, streak: 5)
        .padding()
}
