//
//  ServiceProvidersListView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseFirestore

struct ServiceProvidersListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @State private var selectedFilter: String = "All"
    @State private var providers: [ServiceProvider] = []
    @State private var isLoading: Bool = true
    
    let filterOptions = ["All", "Dog Walking", "Pet Sitting", "Grooming", "Training"]
    
    var filteredProviders: [ServiceProvider] {
        providers.filter { provider in
            let matchesSearch = searchText.isEmpty ||
                               provider.name.localizedCaseInsensitiveContains(searchText) ||
                               provider.service.contains { $0.localizedCaseInsensitiveContains(searchText) }
            
            let matchesFilter = selectedFilter == "All" ||
                               provider.service.contains(selectedFilter)
            
            return matchesSearch && matchesFilter
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    
                    Spacer()
                    
                    Text("Find a Sitter")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Filter tapped")
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search by name or service", text: $searchText)
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
                .padding(.vertical, 12)
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterOptions, id: \.self) { filter in
                            ListFilterChip(
                                title: filter,
                                isSelected: selectedFilter == filter,
                                action: {
                                    selectedFilter = filter
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 12)
                
                // Results Count
                HStack {
                    Text("\(filteredProviders.count) sitters found")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                // Providers List
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading providers...")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        Spacer()
                    }
                } else if filteredProviders.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("No Providers Found")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredProviders) { provider in
                                NavigationLink(destination: ServiceProviderDetailView(provider: provider)) {
                                    ListProviderCard(provider: provider)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadProviders()
        }
    }
    
    // ✅ FIXED: Correct parameter order
    func loadProviders() {
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("serviceProviders").getDocuments { snapshot, error in
            isLoading = false
            
            if let error = error {
                print("❌ Error loading providers: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No providers found")
                providers = []
                return
            }
            
            providers = documents.compactMap { doc -> ServiceProvider? in
                let data = doc.data()
                
                guard let name = data["name"] as? String else {
                    return nil
                }
                
                // Parse service - handle both String and [String]
                let serviceData: [String]
                if let serviceArray = data["service"] as? [String] {
                    serviceData = serviceArray
                } else if let serviceString = data["service"] as? String {
                    serviceData = [serviceString]
                } else {
                    serviceData = []
                }
                
                // ✅ CORRECT PARAMETER ORDER
                return ServiceProvider(
                    id: doc.documentID,
                    name: name,
                    service: serviceData,
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
            
            print("✅ Loaded \(providers.count) providers")
        }
    }
}

// MARK: - Filter Chip
struct ListFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    Color(red: 0.6, green: 0.4, blue: 0.9) :
                    Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1)
                )
                .cornerRadius(20)
        }
    }
}

// MARK: - Provider Card
struct ListProviderCard: View {
    let provider: ServiceProvider
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
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
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(String(provider.name.prefix(1)).uppercased())
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(provider.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", provider.rating))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.black)
                            Text("(\(provider.reviewCount))")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "briefcase.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                            Text("\(provider.completedJobs) jobs")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text("$\(Int(provider.hourlyRate))/hr")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            // Services
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(provider.service, id: \.self) { serviceItem in
                        Text(serviceItem)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
            
            Text(provider.bio.isEmpty ? "No bio available" : provider.bio)
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ServiceProvidersListView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProvidersListView()
    }
}
