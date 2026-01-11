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
    
    init(
        padding: CGFloat = AppConstants.Spacing.medium,
        cornerRadius: CGFloat = AppConstants.CornerRadius.medium,
        shadowColor: Color = AppConstants.Shadows.small,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(AppConstants.Colors.bridgyCard)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
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


