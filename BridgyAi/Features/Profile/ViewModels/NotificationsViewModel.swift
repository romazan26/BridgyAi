//
//  NotificationsViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import Foundation
import Combine
import UserNotifications

class NotificationsViewModel: ObservableObject {
    @Published var isEnabled: Bool = true
    @Published var remindersPerDay: Int = 3
    @Published var motivationType: MotivationType = .encouraging
    @Published var authorizationGranted: Bool = false
    
    private let notificationService: NotificationSettingsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(notificationService: NotificationSettingsServiceProtocol = AppDependencies.shared.notificationSettingsService) {
        self.notificationService = notificationService
        checkAuthorizationStatus()
    }
    
    func loadSettings() {
        notificationService.getSettings()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] settings in
                    self?.isEnabled = settings.isEnabled
                    self?.remindersPerDay = settings.remindersPerDay
                    self?.motivationType = settings.motivationType
                }
            )
            .store(in: &cancellables)
    }
    
    func updateEnabled(_ enabled: Bool) {
        var settings = NotificationSettings.default
        settings.isEnabled = enabled
        settings.remindersPerDay = remindersPerDay
        settings.motivationType = motivationType
        saveSettings(settings: settings)
    }
    
    func saveSettings() {
        let settings = NotificationSettings(
            isEnabled: isEnabled,
            remindersPerDay: remindersPerDay,
            motivationType: motivationType
        )
        saveSettings(settings: settings)
    }
    
    private func saveSettings(settings: NotificationSettings) {
        notificationService.saveSettings(settings)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    // Обновляем локальные значения
                    self?.isEnabled = settings.isEnabled
                    self?.remindersPerDay = settings.remindersPerDay
                    self?.motivationType = settings.motivationType
                }
            )
            .store(in: &cancellables)
    }
    
    func requestAuthorization() {
        notificationService.requestAuthorization()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] granted in
                    self?.authorizationGranted = granted
                    if granted {
                        self?.saveSettings()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationGranted = settings.authorizationStatus == .authorized
            }
        }
    }
}
