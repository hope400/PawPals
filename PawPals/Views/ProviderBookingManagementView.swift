//
//
//  ProviderBookingManagementView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProviderBookingManagementView: View {
    @Environment(\.dismiss) var dismiss
    @State private var bookings: [Booking] = []
    @State private var isLoading: Bool = true
    @State private var selectedFilter: String = "Pending"
    
    let filters = ["Pending", "Confirmed", "Completed", "All"]
    
    var filteredBookings: [Booking] {
        switch selectedFilter {
        case "Pending":
            return bookings.filter { $0.status == "pending" }
        case "Confirmed":
            return bookings.filter { $0.status == "confirmed" }
        case "Completed":
            return bookings.filter { $0.status == "completed" }
        default:
            return bookings
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
                    
                    Text("Manage Bookings")
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
                
                // Filter Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                            }) {
                                Text(filter)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(selectedFilter == filter ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedFilter == filter ?
                                        Color(red: 0.6, green: 0.4, blue: 0.9) :
                                        Color.white
                                    )
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: selectedFilter == filter ? 0 : 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                
                // Stats Summary
                HStack(spacing: 12) {
                    StatCard(
                        icon: "clock.fill",
                        title: "Pending",
                        value: "\(bookings.filter { $0.status == "pending" }.count)",
                        color: .orange
                    )
                    
                    StatCard(
                        icon: "checkmark.circle.fill",
                        title: "Confirmed",
                        value: "\(bookings.filter { $0.status == "confirmed" }.count)",
                        color: .green
                    )
                    
                    StatCard(
                        icon: "checkmark.seal.fill",
                        title: "Completed",
                        value: "\(bookings.filter { $0.status == "completed" }.count)",
                        color: .blue
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                // Bookings List
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading bookings...")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        Spacer()
                    }
                } else if filteredBookings.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("No \(selectedFilter.lowercased()) bookings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredBookings) { booking in
                                ProviderBookingCard(
                                    booking: booking,
                                    onConfirm: {
                                        confirmBooking(booking)
                                    },
                                    onReject: {
                                        rejectBooking(booking)
                                    },
                                    onComplete: {
                                        completeBooking(booking)
                                    }
                                )
                            }
                            
                            Spacer()
                                .frame(height: 80)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadProviderBookings()
        }
    }
    
    // MARK: - Load Provider Bookings
    func loadProviderBookings() {
        guard let providerId = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }
        
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("bookings")
            .whereField("serviceProviderId", isEqualTo: providerId)
            .getDocuments { snapshot, error in
                isLoading = false
                
                if let error = error {
                    print("❌ Error loading provider bookings: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No bookings found")
                    return
                }
                
                bookings = documents.compactMap { doc -> Booking? in
                    let data = doc.data()
                    
                    guard let serviceName = data["serviceName"] as? String,
                          let date = data["date"] as? String,
                          let time = data["time"] as? String,
                          let status = data["status"] as? String else {
                        return nil
                    }
                    
                    return Booking(
                        id: doc.documentID,
                        petOwnerId: data["petOwnerId"] as? String ?? "",
                        petName: data["petName"] as? String ?? "",
                        petOwnerName: data["petOwnerName"] as? String ?? "",
                        serviceProviderId: data["serviceProviderId"] as? String ?? "",
                        serviceProviderName: data["serviceProviderName"] as? String ?? "",
                        serviceProviderPhone: data["serviceProviderPhone"] as? String ?? "",
                        serviceName: serviceName,
                        date: date,
                        time: time,
                        status: status,
                        notes: data["notes"] as? String ?? "",
                        totalPrice: data["totalPrice"] as? Double ?? 0.0
                    )
                }
                
                print("✅ Loaded \(bookings.count) provider bookings")
            }
    }
    
    // MARK: - Confirm Booking
    func confirmBooking(_ booking: Booking) {
        let db = Firestore.firestore()
        db.collection("bookings").document(booking.id)
            .updateData(["status": "confirmed"]) { error in
                if let error = error {
                    print("❌ Error confirming booking: \(error.localizedDescription)")
                } else {
                    print("✅ Booking confirmed")
                    loadProviderBookings()
                }
            }
    }
    
    // MARK: - Reject Booking
    func rejectBooking(_ booking: Booking) {
        let db = Firestore.firestore()
        db.collection("bookings").document(booking.id)
            .updateData(["status": "cancelled"]) { error in
                if let error = error {
                    print("❌ Error rejecting booking: \(error.localizedDescription)")
                } else {
                    print("✅ Booking rejected")
                    loadProviderBookings()
                }
            }
    }
    
    // MARK: - Complete Booking
    func completeBooking(_ booking: Booking) {
        let db = Firestore.firestore()
        db.collection("bookings").document(booking.id)
            .updateData(["status": "completed"]) { error in
                if let error = error {
                    print("❌ Error completing booking: \(error.localizedDescription)")
                } else {
                    print("✅ Booking completed")
                    loadProviderBookings()
                }
            }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Provider Booking Card
struct ProviderBookingCard: View {
    let booking: Booking
    let onConfirm: () -> Void
    let onReject: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Status badge
                HStack(spacing: 6) {
                    Image(systemName: getStatusIcon(booking.status))
                        .font(.system(size: 12))
                    Text(booking.status.uppercased())
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundColor(getStatusColor(booking.status))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(getStatusColor(booking.status).opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
                // Price
                Text("$\(String(format: "%.2f", booking.totalPrice))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            }
            
            // Service and Pet Owner
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.serviceName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text("for \(booking.petOwnerName)")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            
            // Date and Time
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(booking.date)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(booking.time)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
            
            // Action Buttons
            if booking.status == "pending" {
                HStack(spacing: 12) {
                    Button(action: onReject) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Reject")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: onConfirm) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Confirm")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
            } else if booking.status == "confirmed" {
                Button(action: onComplete) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Mark as Completed")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    func getStatusColor(_ status: String) -> Color {
        switch status {
        case "pending": return .orange
        case "confirmed": return .green
        case "completed": return .blue
        case "cancelled": return .red
        default: return .gray
        }
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
}

struct ProviderBookingManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderBookingManagementView()
    }
}
