//
//  OnboardingViewModel.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
    }
}

