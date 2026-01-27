//
//  CardView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppConstants.Spacing.medium
    var cornerRadius: CGFloat = AppConstants.CornerRadius.medium
    var shadowColor: Color = AppConstants.Shadows.small
    var hasGradient: Bool = false
    
    init(
        padding: CGFloat = AppConstants.Spacing.medium,
        cornerRadius: CGFloat = AppConstants.CornerRadius.medium,
        shadowColor: Color = AppConstants.Shadows.small,
        hasGradient: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.hasGradient = hasGradient
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                Group {
                    if hasGradient {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.bridgyCard,
                                AppConstants.Colors.bridgyCard.opacity(0.95)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        AppConstants.Colors.bridgyCard
                    }
                }
            )
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            .shadow(color: shadowColor.opacity(0.5), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title")
                .font(AppConstants.Fonts.headline)
            Text("Card content goes here")
                .font(AppConstants.Fonts.body)
        }
    }
    .padding()
}


