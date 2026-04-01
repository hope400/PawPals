//
//  ServiceProviderHomeView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ServiceProviderHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab        = 0
    @State private var pendingBookings:   [Booking] = []
    @State private var todayBookings:     [Booking] = []
    @State private var allBookings:       [Booking] = []
    @State private var isLoading          = true
    @State private var providerName       = "Provider"

    // Navigation
    @State private var goToBookings       = false
    @State private var goToMessages       = false
    @State private var goToProfile        = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.98)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // ── Header ────────────────────────────────
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Welcome back,")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text(providerName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        // Avatar
                        Button(action: { goToProfile = true }) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.9),
                                            Color(red: 0.65, green: 0.5, blue: 0.95)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 44, height: 44)
                                Text(String(providerName.prefix(1)).uppercased())
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {

                            // ── Stats cards ───────────────────
                            HStack(spacing: 12) {
                                SPStatCard(
                                    title: "Today's Jobs",
                                    value: "\(todayBookings.count)",
                                    icon: "calendar.badge.checkmark",
                                    color: Color(red: 0.6, green: 0.4, blue: 0.9)
                                )
                                SPStatCard(
                                    title: "Pending",
                                    value: "\(pendingBookings.count)",
                                    icon: "clock.badge.exclamationmark",
                                    color: .orange
                                )
                                SPStatCard(
                                    title: "Total Jobs",
                                    value: "\(allBookings.count)",
                                    icon: "briefcase.fill",
                                    color: .green
                                )
                            }
                            .padding(.horizontal, 20)

                            // ── Pending Requests ──────────────
                            if !pendingBookings.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Pending Requests")
                                            .font(.system(size: 18, weight: .bold))
                                        Spacer()
                                        Text("\(pendingBookings.count) new")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.orange)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.orange.opacity(0.1))
                                            .cornerRadius(10)
                                    }
                                    .padding(.horizontal, 20)

                                    VStack(spacing: 12) {
                                        ForEach(pendingBookings) { booking in
                                            SPPendingCard(booking: booking) {
                                                updateBookingStatus(booking.id, status: "confirmed")
                                            } onDecline: {
                                                updateBookingStatus(booking.id, status: "cancelled")
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }

                            // ── Today's Schedule ──────────────
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today's Schedule")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal, 20)

                                if isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(
                                                tint: Color(red: 0.6, green: 0.4, blue: 0.9)))
                                        Spacer()
                                    }
                                    .frame(height: 80)

                                } else if todayBookings.isEmpty {
                                    VStack(spacing: 10) {
                                        Image(systemName: "calendar.badge.checkmark")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray.opacity(0.4))
                                        Text("No appointments today")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 32)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                                    .padding(.horizontal, 20)

                                } else {
                                    VStack(spacing: 10) {
                                        ForEach(todayBookings) { booking in
                                            SPAppointmentCard(booking: booking)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }

                            Spacer().frame(height: 100)
                        }
                        .padding(.top, 4)
                    }
                }

                // ── Bottom Tab Bar ────────────────────────────
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        SPTabItem(icon: "house.fill",    label: "Home",
                                  index: 0, selected: $selectedTab) {}
                        SPTabItem(icon: "calendar",      label: "Bookings",
                                  index: 1, selected: $selectedTab) {
                            goToBookings = true
                        }
                        SPTabItem(icon: "message",       label: "Messages",
                                  index: 2, selected: $selectedTab) {
                            goToMessages = true
                        }
                        SPTabItem(icon: "person.circle", label: "Profile",
                                  index: 3, selected: $selectedTab) {
                            goToProfile = true
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(
                        Color.white
                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: -4)
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToBookings) {
                ServiceProviderBookingsView()
            }
            .navigationDestination(isPresented: $goToMessages) {
                MessagesView()
            }
            .navigationDestination(isPresented: $goToProfile) {
                ServiceProviderProfileView()
            }
        }
        .onAppear {
            loadProviderName()
            loadBookings()
        }
    }

    // MARK: - Firebase

    func loadProviderName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("serviceProviders").document(uid)
            .getDocument { snapshot, _ in
                DispatchQueue.main.async {
                    if let name = snapshot?.data()?["name"] as? String {
                        self.providerName = name.components(separatedBy: " ").first ?? name
                    }
                }
            }
    }

    func loadBookings() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false; return
        }
        isLoading = true

        Firestore.firestore()
            .collection("bookings")
            .whereField("serviceProviderId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    isLoading = false
                    if let error = error {
                        print("❌ Error: \(error.localizedDescription)"); return
                    }

                    let all: [Booking] = snapshot?.documents.compactMap { doc in
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

                    self.allBookings     = all
                    self.pendingBookings = all.filter { $0.status == "pending" }

                    let formatter        = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    let todayStr         = formatter.string(from: Date())
                    self.todayBookings   = all.filter {
                        $0.date == todayStr && $0.status == "confirmed"
                    }
                }
            }
    }

    func updateBookingStatus(_ bookingID: String, status: String) {
        Firestore.firestore()
            .collection("bookings").document(bookingID)
            .updateData(["status": status]) { error in
                if let error = error {
                    print("❌ Update error: \(error.localizedDescription)")
                } else {
                    print("✅ Booking \(status)")
                    DispatchQueue.main.async { loadBookings() }
                }
            }
    }
}

// MARK: - Stat Card
private struct SPStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Pending Request Card
private struct SPPendingCard: View {
    let booking: Booking
    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15))
                        .frame(width: 48, height: 48)
                    Text(String(booking.petOwnerName.prefix(1)).uppercased())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(booking.petOwnerName.isEmpty ? "Pet Owner" : booking.petOwnerName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                    Text(booking.serviceName)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text("$\(String(format: "%.0f", booking.totalPrice))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    Text("pending")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(6)
                }
            }

            HStack(spacing: 16) {
                Label(booking.date, systemImage: "calendar")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Label(booking.time, systemImage: "clock")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                if !booking.petName.isEmpty {
                    Label(booking.petName, systemImage: "pawprint.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }

            if !booking.notes.isEmpty {
                Text("📝 \(booking.notes)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(Color.gray.opacity(0.06))
                    .cornerRadius(8)
            }

            HStack(spacing: 10) {
                Button(action: onDecline) {
                    Text("Decline")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                Button(action: onAccept) {
                    Text("Accept")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color(red: 0.6, green: 0.4, blue: 0.9))
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

// MARK: - Appointment Card
private struct SPAppointmentCard: View {
    let booking: Booking
    var body: some View {
        HStack(spacing: 12) {
            // Time pill
            VStack(spacing: 2) {
                Text(booking.time.components(separatedBy: " ").first ?? "")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                Text(booking.time.components(separatedBy: " ").last ?? "")
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            }
            .frame(width: 44)
            .padding(.vertical, 8)
            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
            .cornerRadius(10)

            // Divider line
            Rectangle()
                .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3))
                .frame(width: 2, height: 40)
                .cornerRadius(1)

            VStack(alignment: .leading, spacing: 3) {
                Text(booking.petOwnerName.isEmpty ? "Pet Owner" : booking.petOwnerName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
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

            Text("Confirmed")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.green)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Tab Item
private struct SPTabItem: View {
    let icon: String
    let label: String
    let index: Int
    @Binding var selected: Int
    let action: () -> Void
    var isSelected: Bool { selected == index }
    var body: some View {
        Button(action: { selected = index; action() }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ServiceProviderHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceProviderHomeView().environmentObject(AppState())
    }
}
