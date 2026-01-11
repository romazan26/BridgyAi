//
//  EmptyStateView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.large) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: AppConstants.Spacing.small) {
                Text(title)
                    .font(AppConstants.Fonts.headline)
                    .foregroundColor(AppConstants.Colors.bridgyText)
                
                Text(message)
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(actionTitle, icon: "plus.circle.fill", action: action)
                    .padding(.horizontal, AppConstants.Spacing.large)
            }
        }
        .padding(AppConstants.Spacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "tray",
        title: "No Flashcard Sets",
        message: "Create your first set to start learning business English",
        actionTitle: "Create Set",
        action: {}
    )
}


