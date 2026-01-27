//
//  NotificationsView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $viewModel.isEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(AppConstants.Colors.bridgyPrimary)
                            .frame(width: 30)
                        Text("Включить уведомления")
                            .font(AppConstants.Fonts.body)
                    }
                }
                .onChange(of: viewModel.isEnabled) { _, newValue in
                    viewModel.updateEnabled(newValue)
                }
            } header: {
                Text("Основные настройки")
            } footer: {
                if !viewModel.isEnabled {
                    Text("Уведомления отключены. Включите их, чтобы получать напоминания об изучении английского.")
                }
            }
            
            if viewModel.isEnabled {
                Section {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                .frame(width: 30)
                            Text("Напоминаний в день")
                                .font(AppConstants.Fonts.body)
                        }
                        
                        Picker("", selection: $viewModel.remindersPerDay) {
                            ForEach(1...6, id: \.self) { count in
                                Text("\(count) раз").tag(count)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Text("Вы получите \(viewModel.remindersPerDay) напоминаний в течение дня")
                            .font(AppConstants.Fonts.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Частота напоминаний")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.medium) {
                        ForEach(MotivationType.allCases, id: \.self) { type in
                            Button(action: {
                                viewModel.motivationType = type
                                viewModel.saveSettings()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(type.title)
                                            .font(AppConstants.Fonts.body)
                                            .foregroundColor(.primary)
                                        
                                        Text(type.description)
                                            .font(AppConstants.Fonts.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if viewModel.motivationType == type {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppConstants.Colors.bridgyPrimary)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Стиль мотивации")
                } footer: {
                    Text("Выберите стиль сообщений, который лучше всего вас мотивирует.")
                }
            }
            
            if !viewModel.authorizationGranted && viewModel.isEnabled {
                Section {
                    Button(action: {
                        viewModel.requestAuthorization()
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(AppConstants.Colors.bridgyWarning)
                            Text("Разрешить уведомления")
                                .font(AppConstants.Fonts.body)
                        }
                    }
                } footer: {
                    Text("Для работы уведомлений необходимо разрешение. Нажмите, чтобы открыть настройки.")
                }
            }
        }
        .navigationTitle("Уведомления")
        .onAppear {
            viewModel.loadSettings()
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
