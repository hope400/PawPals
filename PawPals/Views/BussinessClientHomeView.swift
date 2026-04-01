///
//  BusinessClientHomeView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//
import SwiftUI

struct BusinessClientHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0.97, green: 0.96, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Back button
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
                    
                    // Top Header
                    HStack(spacing: 12) {
                        // Business logo
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.orange,
                                        Color.red
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "building.2")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                        
                        // Business greeting with user name from appState
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hello, \(appState.currentUserName)!")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Business Dashboard")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color.orange)
                        }
                        
                        Spacer()
                        
                        // Notification button
                        NavigationLink(destination: NotificationsView()) {
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
                            // Business Stats
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    BusinessStatCard(
                                        title: "Today's Appointments",
                                        value: "12",
                                        icon: "calendar.badge.clock",
                                        color: Color.orange
                                    )
                                    
                                    BusinessStatCard(
                                        title: "Total Clients",
                                        value: "247",
                                        icon: "person.2",
                                        color: Color.purple
                                    )
                                }
                                
                                HStack(spacing: 12) {
                                    BusinessStatCard(
                                        title: "Monthly Revenue",
                                        value: "$8.5K",
                                        icon: "dollarsign.circle",
                                        color: Color.green
                                    )
                                    
                                    BusinessStatCard(
                                        title: "Pending Requests",
                                        value: "5",
                                        icon: "clock.badge.checkmark",
                                        color: Color.blue
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            
                            // Today's Appointments
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Today's Appointments")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: MyBookingsView()) {
                                        Text("View All")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color.orange)
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                BusinessAppointmentCard(
                                    clientName: "Sarah Johnson",
                                    petName: "Buddy",
                                    time: "10:00 AM",
                                    service: "Vaccination"
                                )
                                .padding(.horizontal, 16)
                                
                                BusinessAppointmentCard(
                                    clientName: "Mike Smith",
                                    petName: "Luna",
                                    time: "2:00 PM",
                                    service: "Checkup"
                                )
                                .padding(.horizontal, 16)
                            }
                            
                            // Quick Actions
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Quick Actions")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                
                                VStack(spacing: 12) {
                                    // 1. Manage Bookings → ProviderBookingManagementView
                                    NavigationLink(destination: ProviderBookingManagementView()) {
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.orange.opacity(0.1))
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Image(systemName: "calendar.badge.checkmark")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(Color.orange)
                                                )
                                            
                                            Text("Manage Bookings")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                    
                                    // 2. View Schedule → ScheduleView
                                    NavigationLink(destination: ScheduleView().environmentObject(appState)) {
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.purple.opacity(0.1))
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Image(systemName: "calendar")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(Color.purple)
                                                )
                                            
                                            Text("View Schedule")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                    
                                    // 3. View Analytics → Placeholder for now
                                    Button(action: {
                                        print("Analytics coming soon!")
                                    }) {
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Image(systemName: "chart.bar")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(Color.blue)
                                                )
                                            
                                            Text("View Analytics")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
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
                
                // Bottom Navigation
                VStack {
                    Spacer()
                    
                    // Inline navigation bar to avoid naming conflicts
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.white.opacity(0.95))
                            .frame(height: 85)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                            .overlay(
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 1),
                                alignment: .top
                            )
                        
                        HStack {
                            NavigationLink(destination: ContentView().environmentObject(appState)) {
                                VStack(spacing: 4) {
                                    Image(systemName: "house.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(selectedTab == 0 ? Color.orange : .gray)
                                    
                                    Text("Home")
                                        .font(.system(size: 10, weight: selectedTab == 0 ? .bold : .medium))
                                        .foregroundColor(selectedTab == 0 ? Color.orange : .gray)
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedTab = 0
                            })
                            
                            Spacer()
                            
                            NavigationLink(destination: ScheduleView().environmentObject(appState)) {
                                VStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 22))
                                        .foregroundColor(selectedTab == 1 ? Color.orange : .gray)
                                    
                                    Text("Schedule")
                                        .font(.system(size: 10, weight: selectedTab == 1 ? .bold : .medium))
                                        .foregroundColor(selectedTab == 1 ? Color.orange : .gray)
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedTab = 1
                            })
                            
                            Spacer()
                            
                            Color.clear
                                .frame(width: 56)
                            
                            Spacer()
                            
                            NavigationLink(destination: MessagesView().environmentObject(appState)) {
                                VStack(spacing: 4) {
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(selectedTab == 2 ? Color.orange : .gray)
                                    
                                    Text("Messages")
                                        .font(.system(size: 10, weight: selectedTab == 2 ? .bold : .medium))
                                        .foregroundColor(selectedTab == 2 ? Color.orange : .gray)
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedTab = 2
                            })
                            
                            Spacer()
                            
                            NavigationLink(destination: ProfileView()) {
                                VStack(spacing: 4) {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(selectedTab == 3 ? Color.orange : .gray)
                                    
                                    Text("Profile")
                                        .font(.system(size: 10, weight: selectedTab == 3 ? .bold : .medium))
                                        .foregroundColor(selectedTab == 3 ? Color.orange : .gray)
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedTab = 3
                            })
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        
                        VStack {
                            NavigationLink(destination: ProviderBookingManagementView()) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.orange,
                                                Color.red
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 56, height: 56)
                                    .shadow(color: Color.orange.opacity(0.4), radius: 10, x: 0, y: 5)
                                    .overlay(
                                        Image(systemName: "calendar.badge.checkmark")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            .offset(y: -24)
                            
                            Spacer()
                        }
                    }
                    .frame(height: 85)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
// ← CRITICAL: BusinessClientHomeView struct closes HERE

// MARK: - Business Stat Card (OUTSIDE BusinessClientHomeView)
struct BusinessStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 24))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Business Appointment Card (OUTSIDE BusinessClientHomeView)
struct BusinessAppointmentCard: View {
    let clientName: String
    let petName: String
    let time: String
    let service: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Time badge
            VStack(spacing: 2) {
                Text(time.split(separator: " ")[0])
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.orange)
                Text(time.split(separator: " ")[1])
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color.orange.opacity(0.7))
            }
            .frame(width: 60)
            .padding(.vertical, 8)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(clientName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                HStack(spacing: 4) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 10))
                    Text(petName)
                        .font(.system(size: 14))
                }
                .foregroundColor(.gray)
                
                Text(service)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            // Action button
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview (OUTSIDE BusinessClientHomeView)
struct BusinessClientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessClientHomeView()
            .environmentObject(AppState())
    }
}
