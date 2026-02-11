//
//  UserProfileView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 3 // Profile tab
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Spacer()
                    
                    Text("Profile")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Edit button
                    NavigationLink(destination: EditProfileView()) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "pencil")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .font(.system(size: 16, weight: .semibold))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.9))
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Picture
                            ZStack(alignment: .bottomTrailing) {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.6, green: 0.4, blue: 0.9),
                                                Color(red: 0.7, green: 0.5, blue: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                                    .frame(width: 132, height: 132)
                                
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 128, height: 128)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray.opacity(0.5))
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            }
                            .padding(.top, 16)
                            
                            // User Info
                            VStack(spacing: 4) {
                                Text("Alex Johnson")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Dog lover & volunteer walker")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                
                                Text("Member since April 2023")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Stats Cards
                        HStack(spacing: 12) {
                            ProfileStatCard(
                                value: "2",
                                label: "Pets Owned",
                                icon: "pawprint.fill"
                            )
                            
                            ProfileStatCard(
                                value: "14",
                                label: "Bookings",
                                icon: "calendar"
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        
                        // Pet Management Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pet Management")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            NavigationLink(destination: MyPetsListView()) {
                                SettingsRow(
                                    icon: "pawprint.fill",
                                    title: "My Pets",
                                    iconColor: Color(red: 0.6, green: 0.4, blue: 0.9)
                                )
                            }
                        }
                        .padding(.bottom, 24)
                        
                        // Account Settings Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account Settings")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            NavigationLink(destination: PaymentMethodsView()) {
                                SettingsRow(
                                    icon: "creditcard.fill",
                                    title: "Payment Methods",
                                    iconColor: Color.blue
                                )
                            }
                            
                            NavigationLink(destination: AddressesView()) {
                                SettingsRow(
                                    icon: "location.fill",
                                    title: "Addresses",
                                    iconColor: Color.green
                                )
                            }
                            
                            NavigationLink(destination: NotificationsView()) {
                                SettingsRow(
                                    icon: "bell.fill",
                                    title: "Notifications",
                                    iconColor: Color.orange
                                )
                            }
                            
                            NavigationLink(destination: ChangePasswordView()) {
                                SettingsRow(
                                    icon: "lock.fill",
                                    title: "Change Password",
                                    iconColor: Color.red
                                )
                            }
                        }
                        .padding(.bottom, 24)
                        
                        // Log Out Button
                        Button(action: {
                            showLogoutConfirmation = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.right.square")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Log Out")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                        .confirmationDialog("Are you sure you want to log out?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                            Button("Log Out", role: .destructive) {
                                handleLogout()
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                    }
                }
            }
            
            // Bottom Navigation
            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab)
            }
        }
        .navigationBarHidden(true)
    }
    
    // 
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            appState.selectedRole = .none
            appState.isLoggedIn = false  // ContentView switches back to welcome!
        } catch {
            print(" Logout error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Profile Stat Card
struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                
                Text(label)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(iconColor.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18))
                )
            
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Placeholder Views
struct MyPetsListView: View {
    var body: some View {
        Text("My Pets List")
            .navigationTitle("My Pets")
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        Text("Payment Methods")
            .navigationTitle("Payment Methods")
    }
}

struct AddressesView: View {
    var body: some View {
        Text("Addresses")
            .navigationTitle("Addresses")
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("Notifications")
            .navigationTitle("Notifications")
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
