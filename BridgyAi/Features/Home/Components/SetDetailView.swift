//
//  SetDetailView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct SetDetailView: View {
    let set: FlashcardSet
    @Environment(\.dismiss) var dismiss
    @State private var showingLearningMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.large) {
                    // Информация о наборе
                    SetInfoCard(set: set)
                    
                    // Статистика
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Статистика")
                            .font(AppConstants.Fonts.headline)
                        
                        HStack {
                            StatCard(title: "Мастерство", value: "\(Int(set.masteryLevel * 100))%")
                            StatCard(title: "Карточки", value: "\(set.totalTerms)")
                            StatCard(title: "Время", value: "\(set.averageStudyTime) мин")
                        }
                    }
                    
                    // Кнопка начала обучения
                    if !set.cards.isEmpty {
                        PrimaryButton("Начать обучение", icon: "play.fill") {
                            showingLearningMode = true
                        }
                    } else {
                        CardView {
                            Text("В этом наборе нет карточек")
                                .font(AppConstants.Fonts.body)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(set.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingLearningMode) {
                LearningModeSelectView(set: set)
            }
        }
    }
}

struct SetInfoCard: View {
    let set: FlashcardSet
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                HStack {
                    Image(systemName: set.workScenario.icon)
                        .font(.title2)
                        .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(set.title)
                            .font(AppConstants.Fonts.headline)
                        
                        Text(set.workScenario.title)
                            .font(AppConstants.Fonts.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                Text(set.description)
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
                
                HStack {
                    BadgeView(text: set.difficulty.rawValue, color: set.difficulty.color)
                    Spacer()
                    Label("\(set.totalTerms) cards", systemImage: "rectangle.stack")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppConstants.Fonts.headline)
                .foregroundColor(AppConstants.Colors.bridgyPrimary)
            
            Text(title)
                .font(AppConstants.Fonts.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(AppConstants.CornerRadius.medium)
    }
}

#Preview {
    SetDetailView(set: FlashcardSet.mock)
}
