//
//  EditProfileView.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 27.01.2026.
//

import SwiftUI
import PhotosUI
import UIKit

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: EditProfileViewModel
    @State private var selectedPhoto: PhotosPickerItem?
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Фото профиля") {
                    HStack {
                        Spacer()
                        
                        if let imageData = viewModel.avatarImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(AppConstants.Colors.bridgyPrimary, lineWidth: 3))
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 100))
                                .foregroundColor(AppConstants.Colors.bridgyPrimary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Выбрать фото")
                        }
                    }
                    
                    if viewModel.avatarImageData != nil {
                        Button(action: {
                            viewModel.removeAvatar()
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Удалить фото")
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                
                Section("Информация") {
                    TextField("Имя", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Section {
                        Text(viewModel.errorMessage)
                            .foregroundColor(AppConstants.Colors.bridgyError)
                            .font(AppConstants.Fonts.caption)
                    }
                }
            }
            .navigationTitle("Редактировать профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        viewModel.saveProfile {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        await MainActor.run {
                            viewModel.avatarImageData = data
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView(user: User(name: "Test User"))
}
