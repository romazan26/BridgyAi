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
            .foregroundColor(style == .filled ? .white : color)
            .padding(.horizontal, AppConstants.Spacing.small)
            .padding(.vertical, 4)
            .background(
                style == .filled
                    ? color
                    : Color.clear
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.small)
                    .stroke(color, lineWidth: style == .outlined ? 1 : 0)
            )
            .cornerRadius(AppConstants.CornerRadius.small)
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


