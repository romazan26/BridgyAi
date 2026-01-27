//
//  ProfileView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Анимированный фон
                AnimatedBackground()
                
                ScrollView {
                VStack(spacing: AppConstants.Spacing.large) {
                    // Профиль пользователя
                    CardView(hasGradient: true) {
                        VStack(spacing: AppConstants.Spacing.medium) {
                            // Фото профиля с градиентной рамкой
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                AppConstants.Colors.bridgyPrimary,
                                                AppConstants.Colors.bridgySecondary
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 90, height: 90)
                                
                                if let imageData = viewModel.avatarImageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 84, height: 84)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(AppConstants.Colors.bridgyCard)
                                        .frame(width: 84, height: 84)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 36))
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
                                        )
                                }
                            }
                            .shadow(color: AppConstants.Colors.bridgyPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            VStack(spacing: 8) {
                                Text(viewModel.userName)
                                    .font(AppConstants.Fonts.headline)
                                    .foregroundColor(AppConstants.Colors.bridgyText)
                                
                                BadgeView(text: viewModel.userLevel.rawValue, color: Color(viewModel.userLevel.color))
                            }
                            
                            Button(action: {
                                showingEditProfile = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Редактировать профиль")
                                }
                                .font(AppConstants.Fonts.body)
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
                                .padding(.horizontal, AppConstants.Spacing.medium)
                                .padding(.vertical, AppConstants.Spacing.small)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    AppConstants.Colors.bridgyPrimary.opacity(0.1),
                                                    AppConstants.Colors.bridgySecondary.opacity(0.05)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                            }
                            .padding(.top, AppConstants.Spacing.small)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Настройки
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        Text("Настройки")
                            .font(AppConstants.Fonts.headline)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: SettingsView()) {
                            SettingsRowCard(title: "Настройки", icon: "gearshape.fill")
                        }
                        
                        NavigationLink(destination: SubscriptionView()) {
                            SettingsRowCard(title: "Подписка", icon: "crown.fill", showBadge: !viewModel.isPremium)
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            SettingsRowCard(title: "Уведомления", icon: "bell.fill")
                        }
                    }
                    }
                    .padding(.vertical)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Профиль")
            .onAppear {
                viewModel.loadUser()
            }
            .sheet(isPresented: $showingEditProfile) {
                if let user = viewModel.currentUser {
                    EditProfileView(user: user)
                }
            }
            .onChange(of: showingEditProfile) { _, isShowing in
                if !isShowing {
                    // Обновляем данные после редактирования
                    viewModel.loadUser()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}


