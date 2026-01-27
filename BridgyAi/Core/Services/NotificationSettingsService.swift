//
//  NotificationSettingsService.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import Foundation
import Combine
import UserNotifications

protocol NotificationSettingsServiceProtocol {
    func getSettings() -> AnyPublisher<NotificationSettings, Error>
    func saveSettings(_ settings: NotificationSettings) -> AnyPublisher<Void, Error>
    func requestAuthorization() -> AnyPublisher<Bool, Error>
}

class NotificationSettingsService: NotificationSettingsServiceProtocol {
    private let settingsKey = "notification_settings"
    
    func getSettings() -> AnyPublisher<NotificationSettings, Error> {
        return Future { promise in
            if let data = UserDefaults.standard.data(forKey: self.settingsKey),
               let settings = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
                promise(.success(settings))
            } else {
                // Возвращаем настройки по умолчанию
                promise(.success(NotificationSettings.default))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveSettings(_ settings: NotificationSettings) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let data = try JSONEncoder().encode(settings)
                UserDefaults.standard.set(data, forKey: self.settingsKey)
                promise(.success(()))
                
                // Обновляем локальные уведомления при изменении настроек
                if settings.isEnabled {
                    self.scheduleNotifications(settings: settings)
                } else {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func requestAuthorization() -> AnyPublisher<Bool, Error> {
        return Future { promise in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(granted))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func scheduleNotifications(settings: NotificationSettings) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        guard settings.isEnabled && settings.remindersPerDay > 0 else { return }
        
        // Распределяем напоминания в течение дня
        let hours = distributeHours(count: settings.remindersPerDay)
        
        for (index, hour) in hours.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = getNotificationTitle(motivation: settings.motivationType)
            content.body = getNotificationBody(motivation: settings.motivationType)
            content.sound = .default
            content.badge = 1
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "reminder_\(index)",
                content: content,
                trigger: trigger
            )
            
            center.add(request)
        }
    }
    
    private func distributeHours(count: Int) -> [Int] {
        // Распределяем напоминания равномерно в течение дня (с 9 до 21)
        guard count > 0 else { return [] }
        guard count <= 12 else { return Array(9...21) }
        
        let startHour = 9
        let endHour = 21
        let totalHours = endHour - startHour + 1
        let step = totalHours / max(1, count - 1)
        
        return (0..<count).map { startHour + ($0 * step) }
    }
    
    private func getNotificationTitle(motivation: MotivationType) -> String {
        switch motivation {
        case .encouraging:
            return "Время учить английский! 📚"
        case .friendly:
            return "Привет! Пора позаниматься 😊"
        case .strict:
            return "Напоминание: время для изучения"
        case .playful:
            return "Эй! Пора учить слова! 🎉"
        }
    }
    
    private func getNotificationBody(motivation: MotivationType) -> String {
        switch motivation {
        case .encouraging:
            return "Ты можешь больше! Открой BridgyAI и продолжай свой путь к успеху 💪"
        case .friendly:
            return "Давай вместе выучим несколько новых слов. Это займет всего пару минут!"
        case .strict:
            return "Ежедневная практика - ключ к успеху. Не пропускай занятия."
        case .playful:
            return "Карточки ждут тебя! Давай сделаем это весело 🎮"
        }
    }
}
