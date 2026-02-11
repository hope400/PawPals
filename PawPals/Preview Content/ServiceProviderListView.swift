//
//  ServiceProviderListView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct ServiceProvidersListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @State private var selectedFilter: String = "All"
    
    let filterOptions = ["All", "Dog Walking", "Pet Sitting", "Grooming", "Training"]
    
    // Sample providers data
    @State private var providers: [ServiceProvider] = [
        ServiceProvider(
            name: "James Rodriguez",
            rating: 4.9,
            reviewCount: 127,
            services: ["Dog Walking", "Pet Sitting"],
            pricePerHour: 25,
            distance: 0.8,
            bio: "Experienced dog walker with 5 years of experience. Loves all breeds!",
            isVerified: true,
            responseTime: "Within 1 hour"
        ),
        ServiceProvider(
            name: "Sarah Mitchell",
            rating: 5.0,
            reviewCount: 89,
            services: ["Pet Sitting", "Grooming"],
            pricePerHour: 30,
            distance: 1.2,
            bio: "Professional pet groomer and certified animal care specialist.",
            isVerified: true,
            responseTime: "Within 30 min"
        ),
        ServiceProvider(
            name: "Michael Chen",
            rating: 4.8,
            reviewCount: 156,
            services: ["Dog Walking", "Training"],
            pricePerHour: 35,
            distance: 2.1,
            bio: "Certified dog trainer specializing in positive reinforcement methods.",
            isVerified: true,
            responseTime: "Within 2 hours"
        ),
        ServiceProvider(
            name: "Emma Thompson",
            rating: 4.7,
            reviewCount: 73,
            services: ["Pet Sitting"],
            pricePerHour: 22,
            distance: 1.5,
            bio: "Loving pet sitter who treats your pets like family. Available 24/7!",
            isVerified: false,
            responseTime: "Within 3 hours"
        ),
        ServiceProvider(
            name: "David Park",
            rating: 4.9,
            reviewCount: 201,
            services: ["Dog Walking", "Pet Sitting", "Training"],
            pricePerHour: 28,
            distance: 0.5,
            bio: "Multi-service provider with expertise in dog training and care.",
            isVerified: true,
            responseTime: "Within 1 hour"
        )
    ]
    
    var filteredProviders: [ServiceProvider] {
        providers.filter { provider in
            let matchesSearch = searchText.isEmpty ||
                               provider.name.localizedCaseInsensitiveContains(searchText) ||
                               provider.services.contains { $0.localizedCaseInsensitiveContains(searchText) }
            
            let matchesFilter = selectedFilter == "All" ||
                               provider.services.contains(selectedFilter)
            
            return matchesSearch && matchesFilter
        }
    }
    
    var body: some View {
        ZStack {
            // Background
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
                    
                    // Filter button
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
                            FilterChip(
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
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredProviders) { provider in
                            NavigationLink(destination: ServiceProviderDetailView(provider: provider)) {
                                ProviderCard(provider: provider)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
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
struct ProviderCard: View {
    let provider: ServiceProvider
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Profile Picture
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(provider.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        if provider.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
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
                            Image(systemName: "location.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                            Text(String(format: "%.1f mi", provider.distance))
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text("$\(provider.pricePerHour)/hr")
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
                    ForEach(provider.services, id: \.self) { service in
                        Text(service)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
            
            // Bio Preview
            Text(provider.bio)
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

// MARK: - Service Provider Model
struct ServiceProvider: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let reviewCount: Int
    let services: [String]
    let pricePerHour: Int
    let distance: Double
    let bio: String
    let isVerified: Bool
    let responseTime: String
}

struct ServiceProvidersListView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProvidersListView()
    }
}
