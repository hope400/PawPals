//
//  ServiceProviderDetailView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct ServiceProviderDetailView: View {
    @Environment(\.dismiss) var dismiss
    let provider: ServiceProvider
    
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
                    
                    Text("Provider Profile")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Favorite tapped")
                    }) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "heart")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .font(.system(size: 18))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        VStack(spacing: 16) {
                            ZStack(alignment: .bottomTrailing) {
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
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Text(String(provider.name.prefix(1)).uppercased())
                                            .font(.system(size: 48, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .bold))
                                    )
                                    .offset(x: -5, y: -5)
                            }
                            .padding(.top, 16)
                            
                            VStack(spacing: 8) {
                                Text(provider.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 12) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.orange)
                                        Text(String(format: "%.1f", provider.rating))
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.black)
                                        Text("(\(provider.reviewCount) reviews)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text("•")
                                        .foregroundColor(.gray)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "briefcase.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        Text("\(provider.completedJobs) jobs")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 8)
                        
                        // Quick Info Cards
                        HStack(spacing: 12) {
                            QuickInfoCard(
                                icon: "clock.fill",
                                title: "Member Since",
                                value: provider.memberSince,
                                color: .blue
                            )
                            
                            QuickInfoCard(
                                icon: "dollarsign.circle.fill",
                                title: "Rate",
                                value: "$\(Int(provider.hourlyRate))/hr",
                                color: .green
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // Services Offered
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Services Offered")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(provider.service, id: \.self) { serviceItem in
                                        ServiceBadge(service: serviceItem)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        // About Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(provider.bio.isEmpty ? "No bio available" : provider.bio)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Contact Information
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Contact Information")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 10) {
                                if !provider.phone.isEmpty {
                                    ContactRow(
                                        icon: "phone.fill",
                                        title: provider.phone,
                                        color: .green
                                    )
                                }
                                
                                if !provider.email.isEmpty {
                                    ContactRow(
                                        icon: "envelope.fill",
                                        title: provider.email,
                                        color: .blue
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Stats Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Provider Stats")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 10) {
                                StatsRow(
                                    icon: "checkmark.circle.fill",
                                    title: "\(provider.completedJobs) jobs completed",
                                    color: .green
                                )
                                
                                StatsRow(
                                    icon: "star.fill",
                                    title: String(format: "%.1f average rating", provider.rating),
                                    color: .orange
                                )
                                
                                StatsRow(
                                    icon: "person.2.fill",
                                    title: "\(provider.reviewCount) happy customers",
                                    color: .purple
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Bottom Actions
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Button(action: {
                            print("Message \(provider.name)")
                        }) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .frame(width: 56, height: 56)
                                .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: BookingView(provider: provider)) {
                            Text("Book Now")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
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
                                .cornerRadius(12)
                                .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Quick Info Card
struct QuickInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Service Badge
struct ServiceBadge: View {
    let service: String
    
    var serviceIcon: String {
        switch service {
        case "Dog Walking": return "figure.walk"
        case "Pet Sitting": return "house.fill"
        case "Grooming": return "scissors"
        case "Training": return "person.fill.checkmark"
        case "Veterinary": return "cross.case.fill"
        default: return "pawprint.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: serviceIcon)
                .font(.system(size: 16))
            
            Text(service)
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Contact Row
struct ContactRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

// MARK: - Stats Row
struct StatsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

// ✅ FIXED PREVIEW
struct ServiceProviderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProviderDetailView(
            provider: ServiceProvider(
                id: "1",
                name: "James Rodriguez",
                service: ["Dog Walking", "Pet Sitting"],  // ✅ FIXED: service (singular, array)
                rating: 4.9,
                hourlyRate: 25.0,
                phone: "(555) 123-4567",
                email: "james@example.com",
                bio: "Experienced dog walker with 5 years of experience.",
                reviewCount: 127,
                completedJobs: 243,
                memberSince: "2023"
            )
        )
    }
}
