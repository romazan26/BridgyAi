//
//  InputField.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import SwiftUI

struct InputField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var icon: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var errorMessage: String? = nil
    var onCommit: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppConstants.Fonts.caption)
                .foregroundColor(AppConstants.Colors.bridgyText)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(isFocused ? AppConstants.Colors.bridgyPrimary : .gray)
                }
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .onSubmit {
                            onCommit?()
                        }
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .onSubmit {
                            onCommit?()
                        }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(AppConstants.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.medium)
                    .stroke(
                        isFocused
                            ? AppConstants.Colors.bridgyPrimary
                            : (errorMessage != nil ? AppConstants.Colors.bridgyError : Color.clear),
                        lineWidth: 2
                    )
            )
            
            if let error = errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(AppConstants.Colors.bridgyError)
                    Text(error)
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(AppConstants.Colors.bridgyError)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InputField(
            title: "Email",
            text: .constant(""),
            placeholder: "Enter your email",
            icon: "envelope"
        )
        
        InputField(
            title: "Password",
            text: .constant(""),
            placeholder: "Enter password",
            icon: "lock",
            isSecure: true,
            errorMessage: "Password is required"
        )
    }
    .padding()
}


