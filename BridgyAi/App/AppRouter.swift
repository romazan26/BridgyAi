//
//  AppRouter.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case home
    case library
    case setDetail(String)
    case learningMode(String, LearningMode)
    case progress
    case profile
    case onboarding
}

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}


