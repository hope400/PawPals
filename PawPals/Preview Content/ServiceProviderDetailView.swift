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
                    
                    Text("Provider Profile")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Favorite button
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
                            // Profile Picture
                            ZStack(alignment: .bottomTrailing) {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray.opacity(0.5))
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                
                                if provider.isVerified {
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
                            }
                            .padding(.top, 16)
                            
                            // Name and Rating
                            VStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    Text(provider.name)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                }
                                
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
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        Text(String(format: "%.1f mi away", provider.distance))
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
                                title: "Response",
                                value: provider.responseTime,
                                color: .blue
                            )
                            
                            QuickInfoCard(
                                icon: "dollarsign.circle.fill",
                                title: "Rate",
                                value: "$\(provider.pricePerHour)/hr",
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
                                    ForEach(provider.services, id: \.self) { service in
                                        ServiceBadge(service: service)
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
                            
                            Text(provider.bio)
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
                        
                        // Experience & Skills
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Experience & Skills")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 10) {
                                ExperienceRow(
                                    icon: "calendar",
                                    title: "5+ years experience",
                                    color: .purple
                                )
                                
                                ExperienceRow(
                                    icon: "checkmark.shield.fill",
                                    title: "Background checked",
                                    color: .green
                                )
                                
                                ExperienceRow(
                                    icon: "heart.text.square.fill",
                                    title: "Pet First Aid certified",
                                    color: .red
                                )
                                
                                ExperienceRow(
                                    icon: "house.fill",
                                    title: "Pet-friendly home",
                                    color: .blue
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Reviews Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Reviews")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: {
                                    print("See all reviews")
                                }) {
                                    Text("See All")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                            
                            VStack(spacing: 12) {
                                ReviewCard(
                                    name: "Sarah J.",
                                    rating: 5.0,
                                    date: "2 days ago",
                                    comment: "James is absolutely wonderful with dogs! My Buddy loved his walk and came home happy and tired. Highly recommend!"
                                )
                                
                                ReviewCard(
                                    name: "Michael T.",
                                    rating: 5.0,
                                    date: "1 week ago",
                                    comment: "Very professional and reliable. Great communication and really cares about the pets."
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
                        // Message Button
                        Button(action: {
                            print("Message tapped")
                        }) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .frame(width: 56, height: 56)
                                .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Book Now Button
                        Button(action: {
                            print("Book now tapped")
                        }) {
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
        default: return "star.fill"
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

// MARK: - Experience Row
struct ExperienceRow: View {
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

// MARK: - Review Card
struct ReviewCard: View {
    let name: String
    let rating: Double
    let date: String
    let comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(name.prefix(1)))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Text(date)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            
            Text(comment)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
        .padding(12)
        .background(Color(red: 0.97, green: 0.96, blue: 0.97))
        .cornerRadius(8)
    }
}

struct ServiceProviderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProviderDetailView(
            provider: ServiceProvider(
                name: "James Rodriguez",
                rating: 4.9,
                reviewCount: 127,
                services: ["Dog Walking", "Pet Sitting"],
                pricePerHour: 25,
                distance: 0.8,
                bio: "Experienced dog walker with 5 years of experience. Loves all breeds!",
                isVerified: true,
                responseTime: "Within 1 hour"
            )
        )
    }
}
