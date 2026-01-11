//
//  LoadingView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."
    var size: CGFloat = 50
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.medium) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(AppConstants.Colors.bridgyPrimary)
            
            if !message.isEmpty {
                Text(message)
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppConstants.Colors.bridgyBackground.opacity(0.8))
    }
}

struct LoadingOverlay: ViewModifier {
    var isLoading: Bool
    var message: String = "Loading..."
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                LoadingView(message: message)
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Bool, message: String = "Loading...") -> some View {
        modifier(LoadingOverlay(isLoading: isLoading, message: message))
    }
}

#Preview {
    ZStack {
        Color.blue
        LoadingView(message: "Loading your data...")
    }
}


