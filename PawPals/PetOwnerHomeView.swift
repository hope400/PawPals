//
//  PetOwnerHomeView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct PetOwnerHomeView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var pets: [Pet] = [
        Pet(name: "Buddy", image: "dog1", isActive: true),
        Pet(name: "Luna", image: "dog2", isActive: false),
        Pet(name: "Max", image: "dog3", isActive: false),
        Pet(name: "Coco", image: "cat1", isActive: false)
    ]
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0.97, green: 0.96, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Header with Back Button
                    HStack(spacing: 12) {
                        // Back button - Links to RoleSelectionView
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
                        
                        Spacer()
                        
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
                        
                        // Greeting text section - uses current user's name from appState
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hello, \(appState.currentUserName)!")
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
                                    
                                    // Add Pet button - Connected to AddPetView
                                    NavigationLink(destination: AddPetView().environmentObject(appState)) {
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
                            
                         
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Quick Actions")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                
                                HStack(spacing: 12) {
                                   
                                    NavigationLink(destination: ServiceProvidersListView()) {
                                        VStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.purple.opacity(0.1))
                                                .frame(width: 48, height: 48)
                                                .overlay(
                                                    Image(systemName: "magnifyingglass")
                                                        .font(.system(size: 22))
                                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                                )
                                            
                                            Text("Find a\nSitter")
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
                                    
                              
                                    NavigationLink(destination: ServiceProvidersListView()) {
                                        VStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 48, height: 48)
                                                .overlay(
                                                    Image(systemName: "cross.case.fill")
                                                        .font(.system(size: 22))
                                                        .foregroundColor(Color.blue)
                                                )
                                            
                                            Text("Book a\nVet")
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
                                    
                                   
                                    Button(action: {
                                        openMaps()
                                    }) {
                                        VStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.green.opacity(0.1))
                                                .frame(width: 48, height: 48)
                                                .overlay(
                                                    Image(systemName: "figure.walk")
                                                        .font(.system(size: 22))
                                                        .foregroundColor(Color.green)
                                                )
                                            
                                            Text("Track\nWalk")
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
                    BottomNavigationBar(selectedTab: $selectedTab, appState: appState)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Helper Function to Open Maps
    func openMaps() {
       
        let latitude = 40.785091
        let longitude = -73.968285
        let mapURL = URL(string: "http://maps.apple.com/?ll=\(latitude),\(longitude)&q=Dog%20Walking")
        
        if let url = mapURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
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
    @ObservedObject var appState: AppState
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
                // Home - goes to ContentView
                NavigationLink(destination: ContentView().environmentObject(appState)) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                        
                        Text("Home")
                            .font(.system(size: 10, weight: selectedTab == 0 ? .bold : .medium))
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    selectedTab = 0
                })
                
                Spacer()
                
                // Schedule - goes to ScheduleView
                NavigationLink(destination: ScheduleView().environmentObject(appState)) {
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
                
                // Messages - goes to MessagesView
                NavigationLink(destination: MessagesView().environmentObject(appState)) {
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
                
                // Exit - goes back to ContentView (logs out)
                NavigationLink(destination: ContentView().environmentObject(appState)) {
                    VStack(spacing: 4) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == 3 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                        
                        Text("Exit")
                            .font(.system(size: 10, weight: selectedTab == 3 ? .bold : .medium))
                            .foregroundColor(selectedTab == 3 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    selectedTab = 3
                    appState.isLoggedIn = false
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

struct PetOwnerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PetOwnerHomeView()
            .environmentObject(AppState())
    }
}
