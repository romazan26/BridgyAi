//
//  View+Extensions.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

extension View {
    func bridgyCardStyle() -> some View {
        self
            .background(AppConstants.Colors.bridgyCard)
            .cornerRadius(AppConstants.CornerRadius.medium)
            .shadow(color: AppConstants.Shadows.small, radius: 5, x: 0, y: 2)
    }
    
    func bridgyPrimaryButton() -> some View {
        self
            .font(AppConstants.Fonts.headline)
            .foregroundColor(.white)
            .padding(.horizontal, AppConstants.Spacing.large)
            .padding(.vertical, AppConstants.Spacing.medium)
            .background(
                LinearGradient(
                    colors: [AppConstants.Colors.bridgyPrimary, AppConstants.Colors.bridgyPrimary.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppConstants.CornerRadius.medium)
            .shadow(color: AppConstants.Colors.bridgyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    func bridgySecondaryButton() -> some View {
        self
            .font(AppConstants.Fonts.headline)
            .foregroundColor(AppConstants.Colors.bridgyPrimary)
            .padding(.horizontal, AppConstants.Spacing.large)
            .padding(.vertical, AppConstants.Spacing.medium)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .stroke(AppConstants.Colors.bridgyPrimary, lineWidth: 2)
            )
    }
}


