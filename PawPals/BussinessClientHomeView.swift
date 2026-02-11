//
//  BussinessClientHomeView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//
import SwiftUI

struct BusinessClientHomeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
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
                    
                    // Business name
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Paws & Claws Clinic")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Business Dashboard")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.orange)
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
                                
                                Button(action: {}) {
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
                                BusinessActionButton(
                                    icon: "calendar.badge.plus",
                                    title: "Add Appointment",
                                    color: Color.orange
                                )
                                
                                BusinessActionButton(
                                    icon: "person.badge.plus",
                                    title: "Add New Client",
                                    color: Color.purple
                                )
                                
                                BusinessActionButton(
                                    icon: "chart.bar",
                                    title: "View Analytics",
                                    color: Color.blue
                                )
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
                BusinessBottomNav(selectedTab: $selectedTab)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Business Stat Card
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

// MARK: - Business Appointment Card
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

// MARK: - Business Action Button
struct BusinessActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            HStack(spacing: 12) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(color)
                    )
                
                Text(title)
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
}

// MARK: - Business Bottom Nav
struct BusinessBottomNav: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            BusinessNavButton(icon: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            Spacer()
            BusinessNavButton(icon: "calendar", title: "Appointments", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            Spacer()
            BusinessNavButton(icon: "person.2", title: "Clients", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            Spacer()
            BusinessNavButton(icon: "chart.bar", title: "Analytics", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
            Spacer()
            BusinessNavButton(icon: "gearshape", title: "Settings", isSelected: selectedTab == 4) {
                selectedTab = 4
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .frame(height: 85)
        .background(Color.white.opacity(0.95))
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1),
            alignment: .top
        )
    }
}

// MARK: - Business Nav Button
struct BusinessNavButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color.orange : .gray)
                
                Text(title)
                    .font(.system(size: 9, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color.orange : .gray)
            }
        }
    }
}

struct BusinessClientHomeView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessClientHomeView()
    }
}
