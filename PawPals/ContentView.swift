//
//  ContentView.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.
//

import SwiftUI

// MARK: - UserData Model (only add this if it doesn't exist elsewhere)
struct UserData: Codable {
    let name: String
    let email: String
    let role: String
}

struct ContentView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        if appState.isLoggedIn {
            homeView
        } else {
            NavigationStack {
                ZStack {
                    // Background color
                    Color(red: 0.93, green: 0.93, blue: 0.98)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Main image container with rounded corners
                        ZStack {
                            // Background rounded rectangle
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.95, green: 0.88, blue: 0.73))
                                .frame(width: 320, height: 320)
                            
                            // Main image with rounded corners
                            Image("dog1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 320, height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        Spacer().frame(height: 50)
                        
                        // Welcome text - personalized if user data exists
                        if let savedUserData = getUserData() {
                            // Personalized welcome for returning users
                            VStack(spacing: 8) {
                                Text("Welcome back,")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(savedUserData.name)
                                    .font(.system(size: 42, weight: .bold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            
                            Spacer().frame(height: 16)
                            
                            Text("Ready to continue with PawPals?")
                                .font(.system(size: 17))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .multilineTextAlignment(.center)
                            
                            Spacer().frame(height: 30)
                            
                            // Direct dashboard access button - FIXED
                            Button(action: {
                                // Update app state directly
                                appState.currentUserName = savedUserData.name
                                appState.currentUserEmail = savedUserData.email
                                appState.selectedRole = getRoleFromString(savedUserData.role) ?? .petOwner
                                appState.isLoggedIn = true
                            }) {
                                HStack(spacing: 12) {
                                    Text("Go to your \(getRoleDisplayName(savedUserData.role)) Dashboard")
                                        .font(.system(size: 20, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
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
                                .cornerRadius(30)
                            }
                            .padding(.horizontal, 32)
                            
                        } else {
                            // New user welcome
                            VStack(spacing: 8) {
                                Text("Welcome to")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("PawPals")
                                    .font(.system(size: 42, weight: .bold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            
                            Spacer().frame(height: 24)
                            
                            Text("The happiest place for your furry\nbest friends to find their local\nsoulmate sitters.")
                                .font(.system(size: 17))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                            
                            Spacer().frame(height: 40)
                            
                            // Get Started button
                            NavigationLink(destination: RoleSelectionView().environmentObject(appState)) {
                                HStack(spacing: 12) {
                                    Text("Get Started")
                                        .font(.system(size: 20, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
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
                                .cornerRadius(30)
                            }
                            .padding(.horizontal, 32)
                        }
                        
                        Spacer().frame(height: 24)
                        
                        // Already have an account - only show for new users
                        if getUserData() == nil {
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                
                                NavigationLink(destination: LoginView(appState: appState)) {
                                    Text("Log In")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                        } else {
                            // Option to switch account (Logout) - FIXED
                            Button(action: {
                                UserDefaults.standard.removeObject(forKey: "userData")
                                appState.isLoggedIn = false
                                appState.selectedRole = .none
                                appState.currentUserName = "User"
                                appState.currentUserEmail = ""
                            }) {
                                Text("Not \(getUserData()?.name ?? "")? Switch Account")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // Get saved user data from UserDefaults
    func getUserData() -> UserData? {
        if let data = UserDefaults.standard.data(forKey: "userData"),
           let userData = try? JSONDecoder().decode(UserData.self, from: data) {
            return userData
        }
        return nil
    }
    
    // Get display name for the user's role - FIXED
    func getRoleDisplayName(_ roleString: String) -> String {
        switch roleString {
        case "pet_owner":
            return "Pet Owner"
        case "service_provider":
            return "Service Provider"
        case "business_client":
            return "Business Client"
        default:
            return "Pet Owner"
        }
    }
    
    // Convert string role to the existing UserRole enum from your app
    func getRoleFromString(_ roleString: String) -> UserRole? {
        switch roleString {
        case "pet_owner":
            return .petOwner
        case "service_provider":
            return .serviceProvider
        case "business_client":
            return .businessClient
        default:
            return nil
        }
    }
    
    // Show the correct home based on user role - FIXED
    @ViewBuilder
    var homeView: some View {
        switch appState.selectedRole {
        case .petOwner:
            PetOwnerHomeView()
                .environmentObject(appState)
        case .serviceProvider:
            ServiceProviderHomeView()
                .environmentObject(appState)
        case .businessClient:
            BusinessClientHomeView()
                .environmentObject(appState)
        case .none:
            PetOwnerHomeView()
                .environmentObject(appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
