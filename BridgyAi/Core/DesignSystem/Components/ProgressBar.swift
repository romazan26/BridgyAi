//
//  ProgressBar.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct ProgressBar: View {
    let progress: Double // 0.0 - 1.0
    var height: CGFloat = 8
    var color: Color = AppConstants.Colors.bridgyPrimary
    var backgroundColor: Color = Color.gray.opacity(0.2)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                // Progress
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(min(max(progress, 0), 1)), height: height)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: height)
    }
}

struct AnimatedProgressBar: View {
    @State private var progress: Double
    let targetProgress: Double
    var height: CGFloat = 8
    var color: Color = AppConstants.Colors.bridgyPrimary
    
    init(progress: Double, height: CGFloat = 8, color: Color = AppConstants.Colors.bridgyPrimary) {
        self._progress = State(initialValue: 0)
        self.targetProgress = progress
        self.height = height
        self.color = color
    }
    
    var body: some View {
        ProgressBar(progress: progress, height: height, color: color)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    progress = targetProgress
                }
            }
            .onChange(of: targetProgress) { newValue in
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    progress = newValue
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(progress: 0.3)
        ProgressBar(progress: 0.7, color: AppConstants.Colors.bridgySuccess)
        AnimatedProgressBar(progress: 0.85)
    }
    .padding()
}


