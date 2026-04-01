//
//  MyBookingsView.swift
//  PawPals
//
//  Created by user286283 on 2/9/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MyBookingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: String = "All"
    @State private var bookings: [Booking] = []
    @State private var isLoading: Bool = true
    
    let filterOptions = ["All", "Pending", "Confirmed", "Completed", "Cancelled"]
    
    var filteredBookings: [Booking] {
        if selectedFilter == "All" {
            return bookings
        } else {
            return bookings.filter { $0.status.lowercased() == selectedFilter.lowercased() }
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
                    
                    Text("My Bookings")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 22)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterOptions, id: \.self) { filter in
                            BookingFilterChip(
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
                .padding(.vertical, 12)
                
                // Results Count
                if !isLoading {
                    HStack {
                        Text("\(filteredBookings.count) booking\(filteredBookings.count == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                
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
                        
                        Image(systemName: selectedFilter == "All" ? "calendar.badge.exclamationmark" : "calendar.badge.clock")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text(selectedFilter == "All" ? "No Bookings Yet" : "No \(selectedFilter) Bookings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text(selectedFilter == "All" ? "Start booking pet services" : "Try selecting a different filter")
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredBookings) { booking in
                                NavigationLink(destination: BookingDetailView(booking: booking)) {
                                    MyBookingCard(booking: booking)
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
            loadBookings()
        }
    }
    
    // ✅ FULLY FIXED: All required parameters included
    func loadBookings() {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }
        
        isLoading = true
        let db = Firestore.firestore()
        
        db.collection("bookings")
            .whereField("petOwnerId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                self.isLoading = false
                
                if let error = error {
                    print("❌ Error loading bookings: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No bookings found")
                    self.bookings = []
                    return
                }
                
                let allBookings = documents.compactMap { doc -> Booking? in
                    let data = doc.data()
                    
                    guard let serviceName = data["serviceName"] as? String,
                          let date = data["date"] as? String,
                          let time = data["time"] as? String,
                          let status = data["status"] as? String else {
                        return nil
                    }
                    
                    // ✅ FIXED: All parameters included in correct order
                    return Booking(
                        id: doc.documentID,
                        petOwnerId: data["petOwnerId"] as? String ?? "",
                        petName: data["petName"] as? String ?? "",                                    // ✅ ADDED
                        petOwnerName: data["petOwnerName"] as? String ?? "",
                        serviceProviderId: data["serviceProviderId"] as? String ?? "",
                        serviceProviderName: data["serviceProviderName"] as? String ?? "",
                        serviceProviderPhone: data["serviceProviderPhone"] as? String ?? "",          // ✅ ADDED
                        serviceName: serviceName,
                        date: date,
                        time: time,
                        status: status,
                        notes: data["notes"] as? String ?? "",
                        totalPrice: data["totalPrice"] as? Double ?? 0.0
                    )
                }
                
                self.bookings = allBookings
                print("✅ Loaded \(allBookings.count) bookings")
            }
    }
}

// MARK: - Booking Filter Chip
struct BookingFilterChip: View {
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

// MARK: - My Booking Card
struct MyBookingCard: View {
    let booking: Booking
    
    var statusColor: Color {
        switch booking.status.lowercased() {
        case "pending":
            return .orange
        case "confirmed":
            return .blue
        case "completed":
            return .green
        case "cancelled":
            return .red
        default:
            return .gray
        }
    }
    
    var statusIcon: String {
        switch booking.status.lowercased() {
        case "pending":
            return "clock.fill"
        case "confirmed":
            return "checkmark.circle.fill"
        case "completed":
            return "checkmark.seal.fill"
        case "cancelled":
            return "xmark.circle.fill"
        default:
            return "circle.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.serviceProviderName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(booking.serviceName)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: statusIcon)
                        .font(.system(size: 12))
                    Text(booking.status.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(statusColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor.opacity(0.1))
                .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(booking.date)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(booking.time)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Total:")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("$\(String(format: "%.2f", booking.totalPrice))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            }
            
            if booking.status.lowercased() == "pending" {
                HStack(spacing: 8) {
                    Button(action: {
                        cancelBooking(booking)
                    }) {
                        Text("Cancel")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        print("Modify booking")
                    }) {
                        Text("Modify")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            } else if booking.status.lowercased() == "completed" {
                Button(action: {
                    print("Rate provider")
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Rate Provider")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    func cancelBooking(_ booking: Booking) {
        let db = Firestore.firestore()
        db.collection("bookings").document(booking.id).updateData([
            "status": "cancelled"
        ]) { error in
            if let error = error {
                print("❌ Error cancelling booking: \(error.localizedDescription)")
            } else {
                print("✅ Booking cancelled successfully")
            }
        }
    }
}

struct MyBookingsView_Previews: PreviewProvider {
    static var previews: some View {
        MyBookingsView()
    }
}
