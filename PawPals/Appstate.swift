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
}
