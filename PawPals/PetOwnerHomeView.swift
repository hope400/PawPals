//
//  PetOwnerHomeView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct PetOwnerHomeView: View {
    @State private var pets: [Pet] = [
        Pet(name: "Buddy", image: "dog-buddy", isActive: true),
        Pet(name: "Luna", image: "cat-luna", isActive: false),
        Pet(name: "Max", image: "dog-max", isActive: false),
        Pet(name: "Coco", image: "rabbit-coco", isActive: false)
    ]
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack(spacing: 12) {
                    // Profile picture
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
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 2)
                        )
                    
                    // Greeting text
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hello, Sarah!")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("4 happy pets today")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
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
                            
                            // Notification badge
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 10, y: -10)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.9))
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Pet Story Carousel
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Existing pets
                                ForEach(pets) { pet in
                                    PetAvatarView(pet: pet)
                                }
                                
                                // Add Pet button
                                NavigationLink(destination: AddPetView()) {
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3),
                                                       style: StrokeStyle(lineWidth: 2, dash: [5]))
                                                .frame(width: 64, height: 64)
                                            
                                            Circle()
                                                .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                                                .frame(width: 64, height: 64)
                                            
                                            Image(systemName: "plus")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        }
                                        
                                        Text("Add Pet")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 16)
                        
                        // Your Next Booking Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Next Booking")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            HStack(spacing: 12) {
                                // Booking details
                                VStack(alignment: .leading, spacing: 8) {
                                    // Service badge
                                    Text("UPCOMING SERVICE")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Text("Dog Walking with James")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text("Today at 2:00 PM")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: BookingDetailsView()) {
                                        Text("View Details")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
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
                                            .cornerRadius(8)
                                            .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 4, x: 0, y: 2)
                                    }
                                }
                                
                                // Booking image
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Image(systemName: "figure.walk")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray.opacity(0.5))
                                    )
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 24)
                        
                        // Quick Actions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Actions")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            HStack(spacing: 12) {
                                NavigationLink(destination: ServiceProvidersListView()) {
                                    QuickActionButton(
                                        icon: "magnifyingglass",
                                        title: "Find a\nSitter",
                                        backgroundColor: Color.purple.opacity(0.1),
                                        iconColor: Color(red: 0.6, green: 0.4, blue: 0.9)
                                    )
                                }
                                
                                NavigationLink(destination: BookServiceView()) {
                                    QuickActionButton(
                                        icon: "cross.case.fill",
                                        title: "Book a\nVet",
                                        backgroundColor: Color.blue.opacity(0.1),
                                        iconColor: Color.blue
                                    )
                                }
                                
                                QuickActionButton(
                                    icon: "figure.walk",
                                    title: "Track\nWalk",
                                    backgroundColor: Color.green.opacity(0.1),
                                    iconColor: Color.green
                                )
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 24)
                        
                        // Recent Activity
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Activity")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: {
                                    print("See all tapped")
                                }) {
                                    Text("See All")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            VStack(spacing: 12) {
                                ActivityRow(
                                    icon: "fork.knife",
                                    title: "Buddy ate breakfast",
                                    time: "2 hours ago",
                                    backgroundColor: Color.orange.opacity(0.1),
                                    iconColor: Color.orange
                                )
                                
                                ActivityRow(
                                    icon: "cross.vial.fill",
                                    title: "Luna's vaccination record",
                                    time: "Yesterday at 5:30 PM",
                                    backgroundColor: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1),
                                    iconColor: Color(red: 0.6, green: 0.4, blue: 0.9)
                                )
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            
            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Pet Model
struct Pet: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let isActive: Bool
    var species: String = ""
    var breed: String = ""
    var birthday: String = ""
    var gender: String = "Male"
    var isSterilized: Bool = false
    var isMicrochipped: Bool = false
    var isVaccinated: Bool = false
    var temperament: String = "Friendly"
    var bio: String = ""
}

// MARK: - Pet Avatar View
struct PetAvatarView: View {
    let pet: Pet
    
    var body: some View {
        NavigationLink(destination: PetProfileView(pet: pet)) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(
                            pet.isActive ?
                            Color(red: 0.6, green: 0.4, blue: 0.9) :
                            Color.gray.opacity(0.2),
                            lineWidth: 2
                        )
                        .frame(width: 68, height: 68)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "pawprint.fill")
                                .foregroundColor(.gray.opacity(0.5))
                        )
                }
                
                Text(pet.name)
                    .font(.system(size: 13, weight: pet.isActive ? .bold : .medium))
                    .foregroundColor(pet.isActive ? .black : .gray)
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
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
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Activity Row
struct ActivityRow: View {
    let icon: String
    let title: String
    let time: String
    let backgroundColor: Color
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                
                Text(time)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Bottom Navigation Bar
struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background with blur
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
                // Home
                Button(action: {
                    selectedTab = 0
                    dismiss() // Dismiss current view to go back to home
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                        
                        Text("Home")
                            .font(.system(size: 10, weight: selectedTab == 0 ? .bold : .medium))
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                    }
                }
                
                Spacer()
                
                // Schedule
                NavigationLink(destination: ScheduleView()) {
                    VStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == 1 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                        
                        Text("Schedule")
                            .font(.system(size: 10, weight: selectedTab == 1 ? .bold : .medium))
                            .foregroundColor(selectedTab == 1 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    selectedTab = 1
                })
                
                Spacer()
                
                // Center Add Button (placeholder)
                Color.clear
                    .frame(width: 56)
                
                Spacer()
                
                // Messages
                NavigationLink(destination: MessagesView()) {
                    VStack(spacing: 4) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == 2 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                        
                        Text("Messages")
                            .font(.system(size: 10, weight: selectedTab == 2 ? .bold : .medium))
                            .foregroundColor(selectedTab == 2 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    selectedTab = 2
                })
                
                Spacer()
                
                // Profile
                NavigationLink(destination: UserProfileView()) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == 3 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                        
                        Text("Profile")
                            .font(.system(size: 10, weight: selectedTab == 3 ? .bold : .medium))
                            .foregroundColor(selectedTab == 3 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    selectedTab = 3
                })
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            // Floating Add Button
            VStack {
                NavigationLink(destination: AddPetView()) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.3, blue: 0.95),
                                    Color(red: 0.65, green: 0.4, blue: 0.9)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4), radius: 10, x: 0, y: 5)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
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

// MARK: - Nav Bar Button
struct NavBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                
                Text(title)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
            }
        }
    }
}

struct PetOwnerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PetOwnerHomeView()
    }
}
