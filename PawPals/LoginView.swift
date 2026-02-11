//
//  LoginView.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var appState: AppState
    @StateObject private var authManager = AuthenticationManager()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
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
                        Text("Login")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        Spacer()
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Logo and title
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Text("Welcome Back!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Login to continue to PawPals")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    
                    // Login Form
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            HStack {
                                Image(systemName: "envelope.fill").foregroundColor(.gray)
                                TextField("Enter your email", text: $email)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1))
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            HStack {
                                Image(systemName: "lock.fill").foregroundColor(.gray)
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1))
                        }
                        
                        // Remember Me & Forgot Password
                        HStack {
                            Button(action: { rememberMe.toggle() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    Text("Remember me")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                            Spacer()
                            NavigationLink(destination: ForgotPasswordView()) {
                                Text("Forgot Password?")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }
                        
                        // Error Message
                        if !authManager.errorMessage.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                                Text(authManager.errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Login Button
                        Button(action: handleLogin) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Login")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.6, green: 0.3, blue: 0.95), Color(red: 0.65, green: 0.4, blue: 0.9)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                        .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
                        
                        // Divider
                        HStack {
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                            Text("OR").font(.system(size: 14, weight: .semibold)).foregroundColor(.gray).padding(.horizontal, 10)
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                        }
                        .padding(.vertical, 10)
                        
                        // Social Login Buttons
                        HStack(spacing: 20) {
                            SocialLoginButton(icon: "applelogo", action: { print("Apple - Coming soon") })
                            SocialLoginButton(icon: "g.circle.fill", action: { print("Google - Coming soon") })
                            SocialLoginButton(icon: "f.circle.fill", action: { print("Facebook - Coming soon") })
                        }
                        
                        // Sign Up Link
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            NavigationLink(destination: SignUpView(appState: appState)) {
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func handleLogin() {
        authManager.login(email: email, password: password) { success in
            if success {
                // Set role from Firebase
                if let userType = authManager.currentUser?.userType {
                    switch userType {
                    case "petOwner":        appState.selectedRole = .petOwner
                    case "serviceProvider": appState.selectedRole = .serviceProvider
                    case "businessClient":  appState.selectedRole = .businessClient
                    default:                appState.selectedRole = .petOwner
                    }
                }
                
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appState.isLoggedIn = true
                }
            }
        }
    }
}

// MARK: - Social Login Button
struct SocialLoginButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                .frame(width: 56, height: 56)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView(appState: AppState())
        }
    }
}
