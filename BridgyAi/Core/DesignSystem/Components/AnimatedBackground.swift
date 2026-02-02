//
//  AnimatedBackground.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct AnimatedBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    
    // Прозрачность фигур зависит от темы
    private var shapeOpacity: CGFloat {
        colorScheme == .dark ? 0.12 : 0.18
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Базовый градиентный фон
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppConstants.Colors.bridgyBackground,
                        AppConstants.Colors.bridgyBackground.opacity(0.95),
                        AppConstants.Colors.bridgyPrimary.opacity(colorScheme == .dark ? 0.05 : 0.03),
                        AppConstants.Colors.bridgyCard.opacity(colorScheme == .dark ? 0.15 : 0.25)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Плавающие фигуры - адаптивная прозрачность для темной/светлой темы
                FloatingShape(
                    color: AppConstants.Colors.bridgyPrimary.opacity(shapeOpacity),
                    size: 250,
                    startX: 0.1,
                    startY: 0.15,
                    duration: 15.0,
                    animate: animate,
                    geometry: geometry
                )
                
                FloatingShape(
                    color: AppConstants.Colors.bridgySecondary.opacity(shapeOpacity * 0.9),
                    size: 200,
                    startX: 0.85,
                    startY: 0.1,
                    duration: 18.0,
                    animate: animate,
                    geometry: geometry
                )
                
                FloatingShape(
                    color: AppConstants.Colors.bridgyPrimary.opacity(shapeOpacity * 0.85),
                    size: 280,
                    startX: 0.25,
                    startY: 0.75,
                    duration: 20.0,
                    animate: animate,
                    geometry: geometry
                )
                
                FloatingShape(
                    color: AppConstants.Colors.bridgySecondary.opacity(shapeOpacity * 0.95),
                    size: 230,
                    startX: 0.75,
                    startY: 0.85,
                    duration: 16.0,
                    animate: animate,
                    geometry: geometry
                )
                
                FloatingShape(
                    color: AppConstants.Colors.bridgyPrimary.opacity(shapeOpacity * 0.9),
                    size: 190,
                    startX: 0.5,
                    startY: 0.45,
                    duration: 14.0,
                    animate: animate,
                    geometry: geometry
                )
                
                FloatingShape(
                    color: AppConstants.Colors.bridgySecondary.opacity(shapeOpacity * 0.8),
                    size: 240,
                    startX: 0.15,
                    startY: 0.6,
                    duration: 17.0,
                    animate: animate,
                    geometry: geometry
                )
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            animate = true
        }
    }
}

struct FloatingShape: View {
    let color: Color
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let duration: Double
    let animate: Bool
    let geometry: GeometryProxy
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    
    var body: some View {
            Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        color,
                        color.opacity(0.6),
                        color.opacity(0.2),
                        color.opacity(0)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: 20)
            .offset(
                x: startX * geometry.size.width - size / 2 + offset.width,
                y: startY * geometry.size.height - size / 2 + offset.height
            )
            .rotationEffect(.degrees(rotation))
            .onAppear {
                if animate {
                    // Плавное плавающее движение
                    withAnimation(
                        .easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                    ) {
                        offset = CGSize(
                            width: CGFloat.random(in: -40...40),
                            height: CGFloat.random(in: -50...50)
                        )
                    }
                    
                    // Медленное вращение
                    withAnimation(
                        .linear(duration: duration * 1.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        rotation = 360
                    }
                }
            }
    }
}

// Альтернативный вариант с более сложными формами
struct AnimatedBackgroundV2: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Базовый градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [
                    AppConstants.Colors.bridgyBackground,
                    AppConstants.Colors.bridgyBackground.opacity(0.98),
                    AppConstants.Colors.bridgyCard.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Плавающие круги
            ForEach(0..<6, id: \.self) { index in
                FloatingCircle(
                    index: index,
                    animate: animate
                )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                animate = true
            }
        }
    }
}

struct FloatingCircle: View {
    let index: Int
    let animate: Bool
    
    private var colors: [Color] {
        [
            AppConstants.Colors.bridgyPrimary.opacity(0.06),
            AppConstants.Colors.bridgySecondary.opacity(0.05),
            AppConstants.Colors.bridgyPrimary.opacity(0.04),
            AppConstants.Colors.bridgySecondary.opacity(0.07),
            AppConstants.Colors.bridgyPrimary.opacity(0.05),
            AppConstants.Colors.bridgySecondary.opacity(0.06)
        ]
    }
    
    private var sizes: [CGFloat] {
        [100, 120, 80, 150, 90, 110]
    }
    
    private var positions: [(x: CGFloat, y: CGFloat)] {
        [
            (0.1, 0.15),
            (0.85, 0.2),
            (0.25, 0.75),
            (0.75, 0.8),
            (0.5, 0.45),
            (0.15, 0.6)
        ]
    }
    
    private var durations: [Double] {
        [8.0, 10.0, 12.0, 9.0, 11.0, 7.0]
    }
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        colors[index],
                        colors[index].opacity(0.5),
                        colors[index].opacity(0)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: sizes[index] / 2
                )
            )
            .frame(width: sizes[index], height: sizes[index])
            .blur(radius: 25)
            .offset(
                x: positions[index].x * UIScreen.main.bounds.width - sizes[index] / 2 + offset.width,
                y: positions[index].y * UIScreen.main.bounds.height - sizes[index] / 2 + offset.height
            )
            .rotationEffect(.degrees(rotation))
            .onAppear {
                if animate {
                    // Плавающее движение
                    withAnimation(
                        .easeInOut(duration: durations[index])
                        .repeatForever(autoreverses: true)
                    ) {
                        offset = CGSize(
                            width: CGFloat.random(in: -50...50),
                            height: CGFloat.random(in: -60...60)
                        )
                    }
                    
                    // Медленное вращение
                    withAnimation(
                        .linear(duration: durations[index] * 2)
                        .repeatForever(autoreverses: false)
                    ) {
                        rotation = 360
                    }
                }
            }
    }
}

#Preview {
    AnimatedBackground()
        .frame(width: 400, height: 800)
}
