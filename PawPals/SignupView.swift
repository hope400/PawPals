//
//  SignupView.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var appState: AppState
    @StateObject private var authManager = AuthenticationManager()
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var agreeToTerms: Bool = false
    
    var isFormValid: Bool {
        !fullName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty &&
        !password.isEmpty && password == confirmPassword &&
        password.count >= 6 && agreeToTerms
    }
    
    var passwordsMatch: Bool {
        password == confirmPassword && !confirmPassword.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        Spacer()
                        Text("Sign Up")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        Spacer()
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Logo and Title
                    VStack(spacing: 12) {
                        Image(systemName: "pawprint.circle.fill")
                            .resizable().scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        Text("Create Account")
                            .font(.system(size: 28, weight: .bold)).foregroundColor(.black)
                        Text("Join PawPals today!")
                            .font(.system(size: 15)).foregroundColor(.gray)
                    }
                    .padding(.top, 30).padding(.bottom, 30)
                    
                    VStack(spacing: 20) {
                        // Full Name
                        FormField(icon: "person.fill", placeholder: "Enter your full name", text: $fullName)
                        
                        // Email
                        FormField(icon: "envelope.fill", placeholder: "Enter your email", text: $email, keyboardType: .emailAddress)
                        
                        // Phone
                        FormField(icon: "phone.fill", placeholder: "Enter your phone number", text: $phoneNumber, keyboardType: .phonePad)
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password").font(.system(size: 14, weight: .semibold)).foregroundColor(.black)
                            HStack {
                                Image(systemName: "lock.fill").foregroundColor(.gray)
                                if isPasswordVisible { TextField("Create a password", text: $password) }
                                else { SecureField("Create a password", text: $password) }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                                }
                            }
                            .padding().background(Color.white).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1))
                            if !password.isEmpty {
                                PasswordRequirement(text: "At least 6 characters", isMet: password.count >= 6).padding(.top, 4)
                            }
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password").font(.system(size: 14, weight: .semibold)).foregroundColor(.black)
                            HStack {
                                Image(systemName: "lock.fill").foregroundColor(.gray)
                                if isConfirmPasswordVisible { TextField("Confirm your password", text: $confirmPassword) }
                                else { SecureField("Confirm your password", text: $confirmPassword) }
                                Button(action: { isConfirmPasswordVisible.toggle() }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                                }
                                if !confirmPassword.isEmpty {
                                    Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(passwordsMatch ? .green : .red)
                                }
                            }
                            .padding().background(Color.white).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1))
                        }
                        
                        // Terms
                        Button(action: { agreeToTerms.toggle() }) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9)).font(.system(size: 22))
                                Text("I agree to the Terms & Conditions and Privacy Policy")
                                    .font(.system(size: 13)).foregroundColor(.black).multilineTextAlignment(.leading)
                            }
                        }.padding(.top, 8)
                        
                        // Error
                        if !authManager.errorMessage.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                                Text(authManager.errorMessage).font(.system(size: 14)).foregroundColor(.red)
                            }
                            .padding().background(Color.red.opacity(0.1)).cornerRadius(12)
                        }
                        
                        // Sign Up Button
                        Button(action: handleSignUp) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Account").font(.system(size: 18, weight: .bold))
                                }
                            }
                            .foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 56)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.6, green: 0.3, blue: 0.95), Color(red: 0.65, green: 0.4, blue: 0.9)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(authManager.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        
                        // Login Link
                        HStack {
                            Text("Already have an account?").font(.system(size: 14)).foregroundColor(.gray)
                            Button(action: { dismiss() }) {
                                Text("Login").font(.system(size: 14, weight: .bold)).foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }.padding(.top, 10)
                    }
                    .padding(.horizontal, 24)
                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func handleSignUp() {
        let userType: String
        switch appState.selectedRole {
        case .petOwner:        userType = "petOwner"
        case .serviceProvider: userType = "serviceProvider"
        case .businessClient:  userType = "businessClient"
        case .none:            userType = "petOwner"
        }
        
        authManager.signUp(email: email, password: password, fullName: fullName, phoneNumber: phoneNumber, userType: userType) { success in
            if success {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appState.isLoggedIn = true
                }
            }
        }
    }
}

// MARK: - Form Field Helper
struct FormField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder.replacingOccurrences(of: "Enter your ", with: "").replacingOccurrences(of: "Enter your ", with: "").capitalized)
                .font(.system(size: 14, weight: .semibold)).foregroundColor(.black)
            HStack {
                Image(systemName: icon).foregroundColor(.gray)
                TextField(placeholder, text: $text)
                    .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    .keyboardType(keyboardType)
            }
            .padding().background(Color.white).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - Password Requirement
struct PasswordRequirement: View {
    let text: String
    let isMet: Bool
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .gray).font(.system(size: 12))
            Text(text).font(.system(size: 12)).foregroundColor(isMet ? .green : .gray)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { SignUpView(appState: AppState()) }
    }
}
