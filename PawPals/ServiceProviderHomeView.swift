//
//  ServiceProviderHomeView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct ServiceProviderHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.97)
                    .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Back button - ISSUE 1 FIXED: Links to RoleSelectionView
                HStack {
                    NavigationLink(destination: RoleSelectionView().environmentObject(appState)) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        appState.isLoggedIn = false
                    })
                    .padding(.leading, 24)
                    
                    Spacer()
                }
                .padding(.top, 12)

                // Top Header - ISSUE 2 FIXED: Shows service provider name
                HStack(spacing: 12) {
                    // Profile picture
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue,
                                    Color.cyan
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    // Greeting text with user name from appState
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hello, \(appState.currentUserName)!")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Service Provider Dashboard")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.blue)
                    }
                    
                    Spacer()
                    
                    // Notification button
                    Button(action: {
                        print("Notifications tapped")
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "bell.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Stats Cards
                        HStack(spacing: 12) {
                            ProviderStatCard(
                                title: "Today's Bookings",
                                value: "3",
                                icon: "calendar",
                                color: Color.blue
                            )
                            
                            ProviderStatCard(
                                title: "This Month",
                                value: "$1,250",
                                icon: "dollarsign.circle",
                                color: Color.green
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Upcoming Appointments
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Upcoming Appointments")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            AppointmentCard(
                                petName: "Buddy",
                                ownerName: "Sarah Johnson",
                                time: "2:00 PM - 3:00 PM",
                                service: "Dog Walking"
                            )
                            .padding(.horizontal, 16)
                            
                            AppointmentCard(
                                petName: "Luna",
                                ownerName: "Mike Smith",
                                time: "4:00 PM - 5:00 PM",
                                service: "Pet Sitting"
                            )
                            .padding(.horizontal, 16)
                        }
                        
                        // Quick Actions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Actions")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            HStack(spacing: 12) {
                                // 1. Set Availability → ScheduleView
                                NavigationLink(destination: ScheduleView().environmentObject(appState)) {
                                    VStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 48, height: 48)
                                            .overlay(
                                                Image(systemName: "calendar.badge.plus")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(Color.blue)
                                            )
                                        
                                        Text("Set\nAvailability")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                }
                                
                                // 2. View Clients → ServiceProvidersListView
                                NavigationLink(destination: ServiceProvidersListView()) {
                                    VStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.purple.opacity(0.1))
                                            .frame(width: 48, height: 48)
                                            .overlay(
                                                Image(systemName: "person.2")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(Color.purple)
                                            )
                                        
                                        Text("View\nClients")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                }
                                
                                // 3. View Earnings → PaymentMethodsView (or create PaymentView)
                                NavigationLink(destination: PaymentMethodsView()) {
                                    VStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.green.opacity(0.1))
                                            .frame(width: 48, height: 48)
                                            .overlay(
                                                Image(systemName: "chart.line.uptrend.xyaxis")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(Color.green)
                                            )
                                        
                                        Text("View\nEarnings")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            
            // Bottom Navigation - ISSUE 3 FIXED: Uses same BottomNavigationBar as PetOwnerHomeView
            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab, appState: appState)
            }
        }
        .navigationBarHidden(true)
        }
    }
}

// MARK: - Provider Stat Card
struct ProviderStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Appointment Card
struct AppointmentCard: View {
    let petName: String
    let ownerName: String
    let time: String
    let service: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Pet avatar
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.blue)
                )
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(petName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text(ownerName)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text(time)
                        .font(.system(size: 12))
                }
                .foregroundColor(Color.blue)
            }
            
            Spacer()
            
            // Service badge
            Text(service)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Provider Quick Action Button
struct ProviderQuickActionButton: View {
    let icon: String
    let title: String
    let backgroundColor: Color
    let iconColor: Color
    
    var body: some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            VStack(spacing: 12) {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundColor(iconColor)
                    )
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct ServiceProviderHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProviderHomeView()
            .environmentObject(AppState())
    }
}
