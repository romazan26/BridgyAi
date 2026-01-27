//
//  BadgeView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct BadgeView: View {
    let text: String
    var color: Color = AppConstants.Colors.bridgyPrimary
    var style: BadgeStyle = .filled
    
    enum BadgeStyle {
        case filled
        case outlined
    }
    
    var body: some View {
        Text(text)
            .font(AppConstants.Fonts.caption)
            .fontWeight(.semibold)
            .foregroundColor(style == .filled ? .white : color)
            .padding(.horizontal, AppConstants.Spacing.small)
            .padding(.vertical, 6)
            .background(
                Group {
                    if style == .filled {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color,
                                color.opacity(0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.clear
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.small)
                    .stroke(
                        style == .outlined
                            ? LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                gradient: Gradient(colors: [Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                        lineWidth: style == .outlined ? 1.5 : 0
                    )
            )
            .cornerRadius(AppConstants.CornerRadius.small)
            .shadow(
                color: style == .filled ? color.opacity(0.3) : Color.clear,
                radius: 4,
                x: 0,
                y: 2
            )
    }
}

#Preview {
    HStack(spacing: 10) {
        BadgeView(text: "A1-A2", color: AppConstants.Colors.bridgySuccess)
        BadgeView(text: "B1-B2", color: AppConstants.Colors.bridgyWarning, style: .outlined)
        BadgeView(text: "Premium", color: AppConstants.Colors.bridgySecondary)
    }
    .padding()
}


