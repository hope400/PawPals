//
//  LoginView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var appState: AppState
    @StateObject private var authManager = AuthenticationManager()

    @State private var email:             String = ""
    @State private var password:          String = ""
    @State private var isPasswordVisible: Bool   = false
    @State private var rememberMe:        Bool   = false
    @State private var isLoading:         Bool   = false
    @State private var errorMessage:      String = ""

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // ── Header ────────────────────────────────
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        Spacer()
                        Text("Login")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        Spacer()
                        Color.clear.frame(width: 32)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 56)  // ← fixed height keeps header compact

                    // ── Logo icon (replaces missing cat image) ─
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.9),
                                            Color(red: 0.65, green: 0.5, blue: 0.95)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 90, height: 90)
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.35),
                                radius: 12, x: 0, y: 6)

                        Text("Welcome back!")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.black)

                        Text("Sign in to continue")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 32)

                    // ── Form fields ───────────────────────────
                    VStack(spacing: 16) {

                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .frame(width: 20)
                                TextField("Enter your email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .font(.system(size: 16))
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                            )
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .frame(width: 20)
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $password)
                                        .font(.system(size: 16))
                                } else {
                                    SecureField("Enter your password", text: $password)
                                        .font(.system(size: 16))
                                }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                            )
                        }

                        // Remember me + Forgot password
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

                        // Error message
                        if !errorMessage.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }

                        // Login button
                        Button(action: { handleLogin() }) {
                            HStack {
                                if isLoading {
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
                            .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3),
                                    radius: 8, x: 0, y: 4)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)

                        // Sign up link
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            NavigationLink(destination: RoleSelectionView().environmentObject(appState)) {
                                Text("Sign Up")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Handle Login

    func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        errorMessage = ""
        isLoading    = true

        // Step 1 — Firebase Auth sign in
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    isLoading    = false
                    errorMessage = error.localizedDescription
                }
                return
            }

            guard let uid = result?.user.uid else {
                DispatchQueue.main.async {
                    isLoading    = false
                    errorMessage = "Could not retrieve user. Please try again."
                }
                return
            }

            // Step 2 — Read userType directly from Firestore
            Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument { snapshot, firestoreError in
                    DispatchQueue.main.async {
                        isLoading = false

                        if let firestoreError = firestoreError {
                            errorMessage = firestoreError.localizedDescription
                            return
                        }

                        let data     = snapshot?.data()
                        let userType = data?["userType"] as? String ?? "petOwner"
                        let fullName = data?["fullName"] as? String ?? ""
                        print("✅ Logged in — userType: '\(userType)'")

                        // Step 3 — Handle BOTH camelCase and underscore formats
                        switch userType {
                        case "serviceProvider", "service_provider":
                            appState.selectedRole = .serviceProvider
                            print("✅ Routing → ServiceProviderHomeView")
                        case "businessClient", "business_client":
                            appState.selectedRole = .businessClient
                            print("✅ Routing → BusinessClientHomeView")
                        default:
                            appState.selectedRole = .petOwner
                            print("✅ Routing → PetOwnerHomeView")
                        }

                        // Step 4 — Save to UserDefaults (underscore format
                        // matches what ContentView's getRoleFromString expects)
                        let roleString: String
                        switch appState.selectedRole {
                        case .serviceProvider: roleString = "service_provider"
                        case .businessClient:  roleString = "business_client"
                        default:               roleString = "pet_owner"
                        }
                        if let encoded = try? JSONEncoder().encode(
                            UserData(name: fullName, email: email, role: roleString)
                        ) {
                            UserDefaults.standard.set(encoded, forKey: "userData")
                        }

                        // Step 5 — Show correct home screen
                        appState.isLoggedIn = true
                    }
                }
        }
    }
}
