//
//  ScheduleView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseFirestore

struct ScheduleView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 1
    @State private var selectedFilter: String = "All"
    @State private var searchText: String = ""
    @State private var filteredProviders: [ServiceProvider] = []
    @State private var isLoading: Bool = true
    
    let filterOptions = ["All", "Dog Walking", "Pet Sitting", "Grooming", "Training", "Veterinary"]
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Text("Schedule")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Filter tapped")
                    }) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search service providers", text: $searchText)
                        .font(.system(size: 16))
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterOptions, id: \.self) { filter in
                            ScheduleServiceFilterChip(
                                title: filter,
                                isSelected: selectedFilter == filter,
                                action: {
                                    selectedFilter = filter
                                    filterProviders()
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 16)
                
                // Service Providers List
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading service providers...")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        Spacer()
                    }
                } else if filteredProviders.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text(searchText.isEmpty ? "No Service Providers" : "No Results")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text(searchText.isEmpty ? "Try a different filter" : "Try a different search")
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredProviders) { provider in
                                NavigationLink(destination:
                                    ServiceProviderDetailView(provider: provider)) {
                                    ScheduleServiceProviderCard(provider: provider)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            
            // Bottom Navigation - INLINE
            VStack {
                Spacer()
                
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
                        
                        Color.clear
                            .frame(width: 56)
                        
                        Spacer()
                        
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
                        
                        NavigationLink(destination: ProfileView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "person.circle.fill")
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
                    
                    VStack {
                        NavigationLink(destination: ServiceProvidersListView()) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.9),
                                            Color(red: 0.7, green: 0.5, blue: 0.95)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    Image(systemName: "plus")
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
        .onAppear {
            loadServiceProviders()
        }
    }
    
    // ✅ FULLY FIXED: Parse service as array
    func loadServiceProviders() {
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("serviceProviders").getDocuments { snapshot, error in
            isLoading = false
            
            if let error = error {
                print("❌ Error loading service providers: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No service providers found")
                return
            }
            
            filteredProviders = documents.compactMap { doc -> ServiceProvider? in
                let data = doc.data()
                
                guard let name = data["name"] as? String else {
                    return nil
                }
                
                // ✅ FIXED: Parse service as array, handle both String and [String]
                let serviceData: [String]
                if let serviceArray = data["service"] as? [String] {
                    serviceData = serviceArray
                } else if let serviceString = data["service"] as? String {
                    serviceData = [serviceString]
                } else {
                    serviceData = []
                }
                
                return ServiceProvider(
                    id: doc.documentID,
                    name: name,
                    service: serviceData,  // ✅ Now an array
                    rating: data["rating"] as? Double ?? 0.0,
                    hourlyRate: data["hourlyRate"] as? Double ?? 0.0,
                    phone: data["phone"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    bio: data["bio"] as? String ?? "",
                    reviewCount: data["reviewCount"] as? Int ?? 0,
                    completedJobs: data["completedJobs"] as? Int ?? 0,
                    memberSince: data["memberSince"] as? String ?? ""
                )
            }
            
            print("✅ Loaded \(filteredProviders.count) service providers")
        }
    }
    
    func filterProviders() {
        loadServiceProviders()
    }
}

// MARK: - Schedule Service Filter Chip
struct ScheduleServiceFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected ?
                    Color(red: 0.6, green: 0.4, blue: 0.9) :
                    Color.white
                )
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Schedule Service Provider Card
struct ScheduleServiceProviderCard: View {
    let provider: ServiceProvider
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(provider.name.prefix(1).uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(provider.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text(provider.service.joined(separator: ", "))  // ✅ FIXED: Display array as string
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    
                    Text(String(format: "%.1f", provider.rating))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    
                    Text("• $\(Int(provider.hourlyRate))/hr")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
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

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .environmentObject(AppState())
    }
}
