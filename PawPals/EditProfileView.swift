//
//  EditProfileView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//
import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fullName: String = "Alex Johnson"
    @State private var bio: String = "Dog lover & volunteer walker"
    @State private var email: String = "alex.johnson@email.com"
    @State private var phone: String = "+1 (555) 123-4567"
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer
                    Color.clear
                        .frame(width: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Profile Picture Section
                        VStack(spacing: 12) {
                            ZStack(alignment: .bottomTrailing) {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.gray.opacity(0.5))
                                        )
                                }
                                
                                
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    Circle()
                                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                        )
                                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                            
                            Text("Change Profile Photo")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        .padding(.bottom, 24)
                        
                        // Form Fields
                        VStack(spacing: 4) {
                            // Full Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                TextField("Enter your name", text: $fullName)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Bio
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bio")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                TextField("Add a short bio", text: $bio)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                TextField("email@example.com", text: $email)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Phone
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Phone Number")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                TextField("+1 (555) 123-4567", text: $phone)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                                    .keyboardType(.phonePad)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Save Button
                VStack(spacing: 0) {
                    Button(action: {
                        saveProfile()
                    }) {
                        Text("Save Changes")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.6, green: 0.3, blue: 0.95),
                                        Color(red: 0.65, green: 0.4, blue: 0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    func saveProfile() {
        // TODO: Save profile to CoreData/Firebase
        print("Saving profile:")
        print("Name: \(fullName)")
        print("Bio: \(bio)")
        print("Email: \(email)")
        print("Phone: \(phone)")
        
        dismiss()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
