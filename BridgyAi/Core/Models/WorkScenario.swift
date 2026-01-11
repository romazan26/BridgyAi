//
//  WorkScenario.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation
import SwiftUI

enum WorkScenario: String, Codable, CaseIterable {
    case meetings = "business_meetings"
    case emails = "email_correspondence"
    case presentations = "presentations"
    case negotiations = "negotiations"
    case smallTalk = "small_talk"
    case jobInterviews = "job_interviews"
    case projectManagement = "project_management"
    case customerService = "customer_service"
    
    var title: String {
        switch self {
        case .meetings: return "Business Meetings"
        case .emails: return "Email Writing"
        case .presentations: return "Presentations"
        case .negotiations: return "Negotiations"
        case .smallTalk: return "Small Talk"
        case .jobInterviews: return "Job Interviews"
        case .projectManagement: return "Project Management"
        case .customerService: return "Customer Service"
        }
    }
    
    var icon: String {
        switch self {
        case .meetings: return "person.2"
        case .emails: return "envelope"
        case .presentations: return "chart.bar"
        case .negotiations: return "hand.raised"
        case .smallTalk: return "bubble.left"
        case .jobInterviews: return "briefcase"
        case .projectManagement: return "calendar"
        case .customerService: return "headphones"
        }
    }
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case beginner = "A1-A2"
    case intermediate = "B1-B2"
    case advanced = "C1-C2"
    
    var color: Color {
        switch self {
        case .beginner: return AppConstants.Colors.bridgySuccess
        case .intermediate: return AppConstants.Colors.bridgyWarning
        case .advanced: return AppConstants.Colors.bridgyError
        }
    }
}


