//
//  Appstate.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//
import Foundation
import SwiftUI

// MARK: - User Role Enum
enum UserRole: String {
    case petOwner = "Pet Owner"
    case serviceProvider = "Service Provider"
    case businessClient = "Business Client"
    case none = ""
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var selectedRole: UserRole = .none
    @Published var isLoggedIn: Bool = false
    @Published var currentUserName: String = "User"
    @Published var currentUserEmail: String = ""
    
    // Method to update user information when logging in
    func login(name: String, email: String, role: UserRole) {
        self.currentUserName = name
        self.currentUserEmail = email
        self.selectedRole = role
        self.isLoggedIn = true
    }
    
    // Method to logout
    func logout() {
        self.currentUserName = "User"
        self.currentUserEmail = ""
        self.selectedRole = .none
        self.isLoggedIn = false
    }
}
