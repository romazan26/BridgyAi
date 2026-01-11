//
//  PrimaryButton.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isEnabled: Bool = true
    
    init(_ title: String, icon: String? = nil, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppConstants.Spacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(AppConstants.Fonts.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppConstants.Spacing.medium)
            .background(
                LinearGradient(
                    colors: isEnabled
                        ? [AppConstants.Colors.bridgyPrimary, AppConstants.Colors.bridgyPrimary.opacity(0.8)]
                        : [Color.gray.opacity(0.5), Color.gray.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppConstants.CornerRadius.medium)
            .shadow(
                color: isEnabled
                    ? AppConstants.Colors.bridgyPrimary.opacity(0.3)
                    : Color.clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(!isEnabled)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton("Start Learning", icon: "play.fill") {}
        PrimaryButton("Disabled Button", isEnabled: false) {}
    }
    .padding()
}


