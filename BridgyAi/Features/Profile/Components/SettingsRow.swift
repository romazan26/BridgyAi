//
//  SettingsRow.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI

struct SettingsRow: View {
    let title: String
    let icon: String
    var showBadge: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppConstants.Colors.bridgyPrimary)
                .frame(width: 30)
            
            Text(title)
                .font(AppConstants.Fonts.body)
            
            Spacer()
            
            if showBadge {
                BadgeView(text: "Premium", color: AppConstants.Colors.bridgySecondary)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .contentShape(Rectangle())
        .foregroundColor(.primary)
    }
}

struct SettingsRowCard: View {
    let title: String
    let icon: String
    var showBadge: Bool = false
    
    var body: some View {
        CardView {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppConstants.Colors.bridgyPrimary)
                    .frame(width: 30)
                
                Text(title)
                    .font(AppConstants.Fonts.body)
                
                Spacer()
                
                if showBadge {
                    BadgeView(text: "Premium", color: AppConstants.Colors.bridgySecondary)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        SettingsRow(title: "Настройки", icon: "gearshape.fill")
        SettingsRowCard(title: "Подписка", icon: "crown.fill", showBadge: true)
    }
    .padding()
}
