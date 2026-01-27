//
//  RecommendedSetsView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct RecommendedSetsView: View {
    let sets: [FlashcardSet]
    let onSelectSet: (FlashcardSet) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
            Text("Рекомендуется для вас")
                .font(AppConstants.Fonts.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppConstants.Spacing.medium) {
                    ForEach(sets) { set in
                        SetCardView(set: set) {
                            onSelectSet(set)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SetCardView: View {
    let set: FlashcardSet
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        CardView(hasGradient: true) {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                HStack {
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
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: set.workScenario.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    }
                    
                    Spacer()
                    
                    if set.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppConstants.Colors.bridgySecondary,
                                        Color.pink
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
                
                Text(set.title)
                    .font(AppConstants.Fonts.headline)
                    .foregroundColor(AppConstants.Colors.bridgyText)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(set.description)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    BadgeView(text: set.difficulty.rawValue, color: set.difficulty.color)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "rectangle.stack")
                            .font(.caption2)
                        Text("\(set.totalTerms)")
                            .font(AppConstants.Fonts.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .frame(width: 200)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                onTap()
            }
        }
    }
}

#Preview {
    RecommendedSetsView(
        sets: [FlashcardSet.mock],
        onSelectSet: { _ in }
    )
}
