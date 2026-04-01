//
//  ForgotpasswordView.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthenticationManager()
    @State private var email: String = ""
    @State private var showSuccessAlert: Bool = false
    
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
                        
                        Text("Reset Password")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Spacer()
                        
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Icon and Instructions
                    VStack(spacing: 16) {
                        Image(systemName: "envelope.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Text("Forgot Password?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Enter your email address and we'll send you a link to reset your password.")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                
                                TextField("Enter your email", text: $email)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
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
                        
                        // Send Link Button
                        Button(action: handleResetPassword) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Send Reset Link")
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
                        .disabled(authManager.isLoading || email.isEmpty)
                        .opacity(email.isEmpty ? 0.6 : 1.0)
                        
                        // Back to Login
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Back to Login")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Email Sent!", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("We've sent a password reset link to \(email). Please check your email.")
        }
    }
    
    func handleResetPassword() {
        authManager.resetPassword(email: email) { success in
            if success {
                showSuccessAlert = true
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
