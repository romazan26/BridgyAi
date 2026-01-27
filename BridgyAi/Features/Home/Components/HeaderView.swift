//
//  HeaderView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct HeaderView: View {
    let userName: String
    @State private var isAnimated = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Привет,")
                        .font(AppConstants.Fonts.title)
                        .foregroundColor(AppConstants.Colors.bridgyText)
                    
                    Text(userName)
                        .font(AppConstants.Fonts.title)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppConstants.Colors.bridgyPrimary,
                                    AppConstants.Colors.bridgySecondary
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .opacity(isAnimated ? 1 : 0)
                .offset(x: isAnimated ? 0 : -20)
                
                Text("Готов учиться?")
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(.secondary)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(x: isAnimated ? 0 : -20)
            }
            
            Spacer()
            
            // Декоративный элемент
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
                    .frame(width: 60, height: 60)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.bridgyPrimary,
                                AppConstants.Colors.bridgySecondary
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .opacity(isAnimated ? 1 : 0)
            .scaleEffect(isAnimated ? 1 : 0.8)
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    HeaderView(userName: "John")
}
