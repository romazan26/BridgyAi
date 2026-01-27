//
//  QuickActionsView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct QuickActionsView: View {
    let onStartQuickSession: () -> Void
    let onCreateSet: () -> Void
    let onPracticeWeak: () -> Void
    let onAddWord: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Быстрые действия")
                .font(AppConstants.Fonts.headline)
                .padding(.horizontal)
            
            HStack(spacing: AppConstants.Spacing.medium) {
                QuickActionButton(
                    title: "Быстрое изучение",
                    icon: "bolt.fill",
                    color: AppConstants.Colors.bridgyPrimary,
                    action: onStartQuickSession
                )
                
                QuickActionButton(
                    title: "Добавить слово",
                    icon: "text.badge.plus",
                    color: AppConstants.Colors.bridgySecondary,
                    action: onAddWord
                )
                
                QuickActionButton(
                    title: "Создать набор",
                    icon: "plus.circle.fill",
                    color: AppConstants.Colors.bridgyPrimary.opacity(0.8),
                    action: onCreateSet
                )
                
                QuickActionButton(
                    title: "Слабые места",
                    icon: "exclamationmark.triangle.fill",
                    color: AppConstants.Colors.bridgyWarning,
                    action: onPracticeWeak
                )
            }
            .padding(.horizontal)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                }
                
                Text(title)
                    .font(AppConstants.Fonts.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppConstants.Spacing.medium)
            .padding(.horizontal, AppConstants.Spacing.small)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        color,
                        color.opacity(0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppConstants.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    QuickActionsView(
        onStartQuickSession: {},
        onCreateSet: {},
        onPracticeWeak: {},
        onAddWord: {}
    )
    .padding()
}
