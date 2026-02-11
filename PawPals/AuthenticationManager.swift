//
//  AuthenticationManager.swift
//  PawPals
//
//  Created by user286283 on 2/9/26.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        // Check if user is already logged in
        if let firebaseUser = auth.currentUser {
            self.isAuthenticated = true
            loadUserData(uid: firebaseUser.uid)
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String, phoneNumber: String, userType: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.isLoading = false
                self.errorMessage = self.getErrorMessage(error)
                completion(false)
                return
            }
            
            guard let firebaseUser = result?.user else {
                self.isLoading = false
                self.errorMessage = "Failed to create user"
                completion(false)
                return
            }
            
            // Create user document in Firestore
            let userData: [String: Any] = [
                "uid": firebaseUser.uid,
                "email": email,
                "fullName": fullName,
                "phoneNumber": phoneNumber,
                "userType": userType,
                "createdAt": Timestamp(),
                "profileImageUrl": "",
                "bio": ""
            ]
            
            self.db.collection("users").document(firebaseUser.uid).setData(userData) { error in
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    completion(false)
                    return
                }
                
                // Create User object
                self.currentUser = User(
                    uid: firebaseUser.uid,
                    email: email,
                    fullName: fullName,
                    phoneNumber: phoneNumber,
                    userType: userType,
                    profileImageUrl: "",
                    bio: ""
                )
                
                self.isAuthenticated = true
                completion(true)
            }
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.isLoading = false
                self.errorMessage = self.getErrorMessage(error)
                completion(false)
                return
            }
            
            guard let firebaseUser = result?.user else {
                self.isLoading = false
                self.errorMessage = "Login failed"
                completion(false)
                return
            }
            
            // Load user data from Firestore
            self.loadUserData(uid: firebaseUser.uid) { success in
                self.isLoading = false
                
                if success {
                    self.isAuthenticated = true
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        do {
            try auth.signOut()
            self.isAuthenticated = false
            self.currentUser = nil
        } catch {
            self.errorMessage = "Failed to logout: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = ""
        
        auth.sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = self.getErrorMessage(error)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    // MARK: - Load User Data
    private func loadUserData(uid: String, completion: ((Bool) -> Void)? = nil) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
                completion?(false)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "User data not found"
                completion?(false)
                return
            }
            
            self.currentUser = User(
                uid: uid,
                email: data["email"] as? String ?? "",
                fullName: data["fullName"] as? String ?? "",
                phoneNumber: data["phoneNumber"] as? String ?? "",
                userType: data["userType"] as? String ?? "petOwner",
                profileImageUrl: data["profileImageUrl"] as? String ?? "",
                bio: data["bio"] as? String ?? ""
            )
            
            completion?(true)
        }
    }
    
    // MARK: - Error Messages
    private func getErrorMessage(_ error: Error) -> String {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email is already registered. Please login instead."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email address. Please check and try again."
        case AuthErrorCode.weakPassword.rawValue:
            return "Password is too weak. Please use at least 6 characters."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password. Please try again."
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found with this email. Please sign up first."
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Please check your connection."
        case AuthErrorCode.tooManyRequests.rawValue:
            return "Too many attempts. Please try again later."
        default:
            return error.localizedDescription
        }
    }
}

// MARK: - User Model
struct User {
    let uid: String
    let email: String
    let fullName: String
    let phoneNumber: String
    let userType: String // "petOwner", "serviceProvider", "businessClient"
    let profileImageUrl: String
    let bio: String
}
