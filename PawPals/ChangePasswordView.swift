//
//  ChangePasswordView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthenticationManager()
    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isCurrentPasswordVisible: Bool = false
    @State private var isNewPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var showSuccessMessage: Bool = false
    
    var passwordsMatch: Bool {
        newPassword == confirmPassword && !confirmPassword.isEmpty
    }
    
    var isFormValid: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        newPassword == confirmPassword &&
        newPassword.count >= 6
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        
                        Spacer()
                        
                        Text("Change Password")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Spacer()
                        
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Icon
                    VStack(spacing: 16) {
                        Image(systemName: "lock.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Text("Reset Your Password")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Enter your current password and choose a new one")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Current Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                
                                if isCurrentPasswordVisible {
                                    TextField("Enter current password", text: $currentPassword)
                                } else {
                                    SecureField("Enter current password", text: $currentPassword)
                                }
                                
                                Button(action: {
                                    isCurrentPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isCurrentPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // New Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                
                                if isNewPasswordVisible {
                                    TextField("Enter new password", text: $newPassword)
                                } else {
                                    SecureField("Enter new password", text: $newPassword)
                                }
                                
                                Button(action: {
                                    isNewPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isNewPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1)
                            )
                            
                            // Password requirements
                            if !newPassword.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ChangePasswordRequirement(
                                        text: "At least 6 characters",
                                        isMet: newPassword.count >= 6
                                    )
                                }
                                .padding(.top, 4)
                            }
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm New Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                
                                if isConfirmPasswordVisible {
                                    TextField("Confirm new password", text: $confirmPassword)
                                } else {
                                    SecureField("Confirm new password", text: $confirmPassword)
                                }
                                
                                Button(action: {
                                    isConfirmPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                                
                                if !confirmPassword.isEmpty {
                                    Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(passwordsMatch ? .green : .red)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Error Message
                        if !authManager.errorMessage.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(authManager.errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Success Message
                        if showSuccessMessage {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Password changed successfully!")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Change Password Button
                        Button(action: handleChangePassword) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Change Password")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
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
                        .disabled(authManager.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func handleChangePassword() {
        // Re-authenticate user with current password first
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            authManager.errorMessage = "User not found"
            return
        }
        
        authManager.isLoading = true
        authManager.errorMessage = ""
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                authManager.isLoading = false
                authManager.errorMessage = "Current password is incorrect"
                return
            }
            
            // Change password after re-authentication
            user.updatePassword(to: newPassword) { error in
                authManager.isLoading = false
                
                if let error = error {
                    authManager.errorMessage = error.localizedDescription
                    return
                }
                
                // Success
                showSuccessMessage = true
                
                // Dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Change Password Requirement (Renamed to avoid conflict)
struct ChangePasswordRequirement: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .gray)
                .font(.system(size: 12))
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isMet ? .green : .gray)
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
