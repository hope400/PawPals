//
//  BookingDetailView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseFirestore

struct BookingDetailView: View {
    @Environment(\.dismiss) var dismiss
    let booking: Booking
    
    var statusColor: Color {
        switch booking.status {
        case "pending": return .orange
        case "confirmed": return .green
        case "completed": return .blue
        case "cancelled": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        .padding(.leading, 16)
                        .frame(width: 100, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    Text("Booking Details")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 100)
                }
                .frame(height: 50)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                .overlay(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Status Banner
                        HStack {
                            Image(systemName: getStatusIcon(booking.status))
                                .font(.system(size: 24))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(booking.status.capitalized)
                                    .font(.system(size: 18, weight: .bold))
                                
                                Text(getStatusMessage(booking.status))
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(20)
                        .background(statusColor)
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Service Info
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Service Information")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 12) {
                                DetailRow(icon: "scissors", title: "Service", value: booking.serviceName)
                                DetailRow(icon: "person.fill", title: "Provider", value: booking.serviceProviderName)
                                DetailRow(icon: "pawprint.fill", title: "Pet Owner", value: booking.petOwnerName)
                                DetailRow(icon: "calendar", title: "Date", value: booking.date)
                                DetailRow(icon: "clock", title: "Time", value: booking.time)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 16)
                        
                        // Notes (if any)
                        if !booking.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Notes")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(booking.notes)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .lineLimit(nil)
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 16)
                        }
                        
                        // Payment Info
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Payment Details")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Total Price")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", booking.totalPrice))")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 16)
                        
                        // Action Buttons
                        if booking.status == "pending" || booking.status == "confirmed" {
                            VStack(spacing: 12) {
                                Button(action: {
                                    // Chat action
                                }) {
                                    HStack {
                                        Image(systemName: "message.fill")
                                            .font(.system(size: 18))
                                        Text("Message Provider")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer()
                            .frame(height: 80)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func getStatusIcon(_ status: String) -> String {
        switch status {
        case "pending": return "clock.fill"
        case "confirmed": return "checkmark.circle.fill"
        case "completed": return "checkmark.seal.fill"
        case "cancelled": return "xmark.circle.fill"
        default: return "clock.fill"
        }
    }
    
    func getStatusMessage(_ status: String) -> String {
        switch status {
        case "pending": return "Waiting for provider confirmation"
        case "confirmed": return "Your booking is confirmed!"
        case "completed": return "Service completed successfully"
        case "cancelled": return "This booking was cancelled"
        default: return "Unknown status"
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
        }
    }
}

struct BookingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDetailView(booking: Booking(
            id: "1",
            petOwnerId: "owner123",
            petName: "bob",
            petOwnerName: "John Smith",
            serviceProviderId: "provider456",
            serviceProviderName: "James Rodriguez",
            serviceProviderPhone: "111-222-3333",
            serviceName: "Dog Walking",
            date: "03/25/2026",
            time: "2:00 PM",
            status: "confirmed",
            notes: "Please bring treats!",
            totalPrice: 25.0
        ))
    }
}
