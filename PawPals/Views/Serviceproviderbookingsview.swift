//
//  ServiceProviderBookingsView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ServiceProviderBookingsView: View {
    @Environment(\.dismiss) var dismiss

    @State private var allBookings:    [Booking] = []
    @State private var isLoading:      Bool      = true
    @State private var selectedFilter: String    = "All"

    let filters = ["All", "Pending", "Confirmed", "Completed", "Cancelled"]

    var filteredBookings: [Booking] {
        switch selectedFilter {
        case "Pending":   return allBookings.filter { $0.status == "pending" }
        case "Confirmed": return allBookings.filter { $0.status == "confirmed" }
        case "Completed": return allBookings.filter { $0.status == "completed" }
        case "Cancelled": return allBookings.filter { $0.status == "cancelled" }
        default:          return allBookings
        }
    }

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.98).ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ────────────────────────────────────
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    Spacer()
                    Text("My Bookings")
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Color.clear.frame(width: 32)
                }
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(Color(red: 0.97, green: 0.96, blue: 0.98))
                .overlay(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                        .frame(height: 1),
                    alignment: .bottom
                )

                // ── Filter tabs ───────────────────────────────
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: { selectedFilter = filter }) {
                                Text(filter)
                                    .font(.system(size: 13, weight: selectedFilter == filter ? .bold : .medium))
                                    .foregroundColor(selectedFilter == filter ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedFilter == filter
                                            ? Color(red: 0.6, green: 0.4, blue: 0.9)
                                            : Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }

                // ── Booking list ──────────────────────────────
                if isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(
                            tint: Color(red: 0.6, green: 0.4, blue: 0.9)))
                        .scaleEffect(1.3)
                    Spacer()

                } else if filteredBookings.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("No \(selectedFilter.lowercased()) bookings")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    Spacer()

                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(filteredBookings) { booking in
                                SPBookingDetailCard(booking: booking) { newStatus in
                                    updateStatus(booking.id, status: newStatus)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { loadBookings() }
    }

    func loadBookings() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false; return
        }
        Firestore.firestore()
            .collection("bookings")
            .whereField("serviceProviderId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    isLoading = false
                    if let error = error {
                        print("❌ \(error.localizedDescription)"); return
                    }
                    self.allBookings = snapshot?.documents.compactMap { doc in
                        let d = doc.data()
                        guard let serviceName = d["serviceName"] as? String,
                              let date        = d["date"]        as? String,
                              let time        = d["time"]        as? String,
                              let status      = d["status"]      as? String
                        else { return nil }
                        return Booking(
                            id:                  doc.documentID,
                            petOwnerId:          d["petOwnerId"]          as? String ?? "",
                            petName:             d["petName"]             as? String ?? "",
                            petOwnerName:        d["petOwnerName"]        as? String ?? "Pet Owner",
                            serviceProviderId:   d["serviceProviderId"]   as? String ?? "",
                            serviceProviderName: d["serviceProviderName"] as? String ?? "",
                            serviceProviderPhone:d["serviceProviderPhone"] as? String ?? "",
                            serviceName:         serviceName,
                            date:                date,
                            time:                time,
                            status:              status,
                            notes:               d["notes"]               as? String ?? "",
                            totalPrice:          d["totalPrice"]          as? Double ?? 0.0
                        )
                    } ?? []
                }
            }
    }

    func updateStatus(_ id: String, status: String) {
        Firestore.firestore()
            .collection("bookings").document(id)
            .updateData(["status": status]) { _ in
                DispatchQueue.main.async { loadBookings() }
            }
    }
}

// MARK: - Full booking card with actions
private struct SPBookingDetailCard: View {
    let booking: Booking
    let onStatusChange: (String) -> Void

    var statusColor: Color {
        switch booking.status {
        case "confirmed": return .green
        case "completed": return Color(red: 0.6, green: 0.4, blue: 0.9)
        case "cancelled": return .red
        default:          return .orange
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // Top row
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15))
                        .frame(width: 50, height: 50)
                    Text(String(booking.petOwnerName.prefix(1)).uppercased())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(booking.petOwnerName.isEmpty ? "Pet Owner" : booking.petOwnerName)
                        .font(.system(size: 15, weight: .bold))
                    HStack(spacing: 6) {
                        Text(booking.serviceName)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        if !booking.petName.isEmpty {
                            Text("· \(booking.petName)")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.0f", booking.totalPrice))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(booking.status.capitalized)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(6)
                }
            }

            // Info row
            HStack(spacing: 16) {
                Label(booking.date, systemImage: "calendar")
                Label(booking.time, systemImage: "clock")
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)

            if !booking.notes.isEmpty {
                Text("📝 \(booking.notes)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(Color.gray.opacity(0.06))
                    .cornerRadius(8)
            }

            // Action buttons based on status
            if booking.status == "pending" {
                HStack(spacing: 10) {
                    Button(action: { onStatusChange("cancelled") }) {
                        Text("Decline")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity).frame(height: 38)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    Button(action: { onStatusChange("confirmed") }) {
                        Text("Accept")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 38)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .cornerRadius(10)
                    }
                }
            } else if booking.status == "confirmed" {
                Button(action: { onStatusChange("completed") }) {
                    Text("Mark as Completed")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 38)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}
