//
//  RoleSelectionView.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.
//

import SwiftUI

struct RoleSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
                // Background color
                Color(red: 0.96, green: 0.96, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text("Role Selection")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // Invisible spacer for balance
                        Color.clear
                            .frame(width: 44)
                    }
                    .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Title section
                            VStack(spacing: 12) {
                                Text("Who are you?")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Choose your profile type to get started")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            .padding(.top, 32)
                            
                            // Role Cards
                            VStack(spacing: 20) {
                                // Pet Owner Card
                                RoleCard(
                                    backgroundColor: Color(red: 0.98, green: 0.96, blue: 0.91),
                                    icon: "pawprint.fill",
                                    iconColor: Color(red: 0.6, green: 0.4, blue: 0.9),
                                    title: "Pet Owner",
                                    description: "I'm looking for high-quality care and services for my pet",
                                    imageName: "person-dog", // Placeholder
                                    appState: appState,
                                    role: .petOwner
                                )
                                
                                // Service Provider Card
                                RoleCard(
                                    backgroundColor: Color(red: 0.96, green: 0.88, blue: 0.73),
                                    icon: "scissors",
                                    iconColor: Color(red: 0.6, green: 0.4, blue: 0.9),
                                    title: "Service Provider",
                                    description: "I want to offer sitting, walking, or grooming services",
                                    imageName: "person-cat", // Placeholder
                                    appState: appState,
                                    role: .serviceProvider
                                )
                                
                                // Business Client Card
                                RoleCard(
                                    backgroundColor: Color(red: 0.85, green: 0.92, blue: 0.73),
                                    icon: "building.2.fill",
                                    iconColor: Color(red: 0.6, green: 0.4, blue: 0.9),
                                    title: "Business Client",
                                    description: "I represent a veterinary clinic or a pet retail business",
                                    imageName: "business-building", // Placeholder
                                    appState: appState,
                                    role: .businessClient
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
        }
    }


// Reusable Role Card Component
struct RoleCard: View {
    let backgroundColor: Color
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let imageName: String
    @ObservedObject var appState: AppState
    let role: UserRole
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section with rounded top
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(backgroundColor)
                    .frame(height: 200)
                
                // Placeholder for illustration
                // TODO: Replace with actual images
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray.opacity(0.3))
            }
            
            // Content section
            HStack(alignment: .top, spacing: 12) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                
                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .lineSpacing(2)
                }
                
                Spacer()
                
                // Select button with NavigationLink
                NavigationLink(destination: LoginView(appState: appState)) {
                    Text("Select")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
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
                        .cornerRadius(20)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    appState.selectedRole = role
                })
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView()
    }
}
