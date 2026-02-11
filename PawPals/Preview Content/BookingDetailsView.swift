//
//  BookingDetailsView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//
import SwiftUI

struct BookingDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
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
                    
                    Text("Booking Details")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Message button
                    Button(action: {
                        print("Message tapped")
                    }) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "message.fill")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .font(.system(size: 16))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Status Badge
                        HStack {
                            Spacer()
                            Text("CONFIRMED")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.green)
                                .cornerRadius(20)
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        // Service Card
                        VStack(spacing: 16) {
                            // Service Icon
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "figure.walk")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            
                            // Service Title
                            Text("Dog Walking")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            // Provider Info
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.gray.opacity(0.5))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("James Rodriguez")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(.orange)
                                        Text("4.9")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.gray)
                                        Text("• Dog Walker")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 16)
                        
                        // Details Section
                        VStack(spacing: 12) {
                            DetailRow(
                                icon: "calendar",
                                title: "Date",
                                value: "Today, Feb 5, 2026",
                                iconColor: Color.blue
                            )
                            
                            DetailRow(
                                icon: "clock.fill",
                                title: "Time",
                                value: "2:00 PM - 3:00 PM",
                                iconColor: Color.purple
                            )
                            
                            DetailRow(
                                icon: "pawprint.fill",
                                title: "Pet",
                                value: "Buddy",
                                iconColor: Color(red: 0.6, green: 0.4, blue: 0.9)
                            )
                            
                            DetailRow(
                                icon: "mappin.circle.fill",
                                title: "Location",
                                value: "Central Park, New York",
                                iconColor: Color.green
                            )
                            
                            DetailRow(
                                icon: "dollarsign.circle.fill",
                                title: "Price",
                                value: "$25.00",
                                iconColor: Color.orange
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // Notes Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Special Instructions")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Buddy loves to chase tennis balls! Please bring his favorite blue ball from the front door.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 16)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            // Contact Provider
                            Button(action: {
                                print("Contact provider tapped")
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "phone.fill")
                                        .font(.system(size: 18))
                                    Text("Contact Provider")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
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
                            
                            // Cancel Booking
                            Button(action: {
                                print("Cancel booking tapped")
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "xmark.circle")
                                        .font(.system(size: 18))
                                    Text("Cancel Booking")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            RoundedRectangle(cornerRadius: 10)
                .fill(iconColor.opacity(0.1))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18))
                )
            
            // Title and Value
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct BookingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDetailsView()
    }
}
