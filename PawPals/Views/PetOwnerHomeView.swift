//
//  PetOwnerHomeView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

private struct HomeBooking: Identifiable {
    let id: String
    let serviceName: String
    let petName: String
    let serviceProviderName: String
    let date: String
    let time: String
    let status: String
    let createdAt: Date
}

struct PetOwnerHomeView: View {

    @State private var selectedTab      = 0
    @State private var userName         = "Friend"

    @State private var pets: [Pet]      = []
    @State private var isLoadingPets    = true

    @State private var upcomingBooking: HomeBooking?  = nil
    @State private var recentBookings: [HomeBooking]  = []
    @State private var isLoadingBookings              = true

    @State private var goToBookService  = false
    @State private var goToAddPet       = false
    @State private var goToMessages     = false
    @State private var goToProfile      = false   // ← NEW

    @State private var refreshID        = UUID()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {

                Color(red: 0.97, green: 0.96, blue: 0.98)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // ── Header ────────────────────────────────
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Hello, \(userName)!")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                            Text("How are your pets today?")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 22) {

                            // ── My Pets ───────────────────────
                            VStack(alignment: .leading, spacing: 14) {
                                Text("My Pets")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal, 20)

                                if isLoadingPets {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(
                                                tint: Color(red: 0.6, green: 0.4, blue: 0.9)))
                                        Spacer()
                                    }
                                    .frame(height: 90)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 14) {

                                            if pets.isEmpty {
                                                VStack(spacing: 8) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color.gray.opacity(0.1))
                                                            .frame(width: 70, height: 70)
                                                        Image(systemName: "pawprint")
                                                            .font(.system(size: 28))
                                                            .foregroundColor(.gray)
                                                    }
                                                    Text("No pets yet")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                }
                                            }

                                            ForEach(pets) { pet in
                                                VStack(spacing: 6) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15))
                                                            .frame(width: 70, height: 70)

                                                        if let urlStr = pet.imageURL,
                                                           !urlStr.isEmpty,
                                                           let url = URL(string: urlStr) {
                                                            AsyncImage(url: url) { phase in
                                                                if let img = phase.image {
                                                                    img.resizable()
                                                                        .scaledToFill()
                                                                        .frame(width: 70, height: 70)
                                                                        .clipShape(Circle())
                                                                } else {
                                                                    Image(systemName: "pawprint.fill")
                                                                        .font(.system(size: 28))
                                                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                                                }
                                                            }
                                                        } else {
                                                            Image(systemName: "pawprint.fill")
                                                                .font(.system(size: 28))
                                                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                                        }
                                                    }
                                                    Text(pet.name)
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .foregroundColor(.black)
                                                    Text(pet.breed)
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.gray)
                                                }
                                            }

                                            Button(action: { goToAddPet = true }) {
                                                VStack(spacing: 8) {
                                                    ZStack {
                                                        Circle()
                                                            .strokeBorder(
                                                                Color(red: 0.6, green: 0.4, blue: 0.9),
                                                                style: StrokeStyle(lineWidth: 2, dash: [5])
                                                            )
                                                            .frame(width: 70, height: 70)
                                                        Image(systemName: "plus")
                                                            .font(.system(size: 24))
                                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                                    }
                                                    Text("Add")
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }

                            // ── Upcoming Booking ──────────────
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Upcoming Booking")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal, 20)

                                if isLoadingBookings {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(
                                                tint: Color(red: 0.6, green: 0.4, blue: 0.9)))
                                        Spacer()
                                    }
                                    .frame(height: 70)

                                } else if let booking = upcomingBooking {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15))
                                                .frame(width: 52, height: 52)
                                            Image(systemName: serviceIcon(for: booking.serviceName))
                                                .font(.system(size: 22))
                                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(booking.serviceName) – \(booking.petName)")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.black)
                                            Text("\(booking.date) · \(booking.time) · \(booking.serviceProviderName)")
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(booking.status.capitalized)
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(statusColor(booking.status))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(statusColor(booking.status).opacity(0.12))
                                            .cornerRadius(8)
                                    }
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                                    .padding(.horizontal, 20)

                                } else {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 52, height: 52)
                                            Image(systemName: "calendar.badge.plus")
                                                .font(.system(size: 22))
                                                .foregroundColor(.gray)
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("No upcoming bookings")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.black)
                                            Text("Book a service to get started")
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                                    .padding(.horizontal, 20)
                                }
                            }

                            // ── Recent Activity ───────────────
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Recent Activity")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal, 20)

                                if isLoadingBookings {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(
                                                tint: Color(red: 0.6, green: 0.4, blue: 0.9)))
                                        Spacer()
                                    }
                                    .frame(height: 60)
                                } else if recentBookings.isEmpty {
                                    Text("No recent activity yet.")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 20)
                                } else {
                                    VStack(spacing: 10) {
                                        ForEach(recentBookings) { booking in
                                            HomeActivityRow(
                                                icon: serviceIcon(for: booking.serviceName),
                                                color: statusColor(booking.status),
                                                title: "\(booking.serviceName) – \(booking.petName)",
                                                subtitle: "\(booking.date) · \(booking.time) · \(booking.status.capitalized)"
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }

                            Spacer().frame(height: 90)
                        }
                    }
                }

                // ── Bottom Tab Bar ────────────────────────────
                HStack(spacing: 0) {

                    HomeTabBarItem(icon: "house.fill", label: "Home",
                                   index: 0, selected: $selectedTab) {}

                    HomeTabBarItem(icon: "calendar", label: "Schedule",
                                   index: 1, selected: $selectedTab) {
                        goToBookService = true
                    }

                    Button(action: { goToAddPet = true }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .frame(width: 56, height: 56)
                                .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4),
                                        radius: 8, x: 0, y: 4)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)

                    HomeTabBarItem(icon: "message", label: "Messages",
                                   index: 3, selected: $selectedTab) {
                        goToMessages = true
                    }

                    HomeTabBarItem(icon: "person.circle", label: "Profile",
                                   index: 4, selected: $selectedTab) {
                        goToProfile = true   // ← navigate to profile
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
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToBookService) { BookServiceView() }
            .navigationDestination(isPresented: $goToAddPet)      { AddPetView() }
            .navigationDestination(isPresented: $goToMessages)    { MessagesView() }
            .navigationDestination(isPresented: $goToProfile)     { ProfileView() }
        }
        .id(refreshID)
        .onAppear {
            refreshID = UUID()
            loadUserName()
            loadPetsFromFirebase()
            loadBookingsFromFirebase()
        }
    }

    // MARK: - Firebase: User

    func loadUserName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            DispatchQueue.main.async {
                if let name = snapshot?.data()?["fullName"] as? String, !name.isEmpty {
                    self.userName = name.components(separatedBy: " ").first ?? name
                } else {
                    self.userName = Auth.auth().currentUser?.email ?? "Friend"
                }
            }
        }
    }

    // MARK: - Firebase: Pets

    func loadPetsFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoadingPets = false; return
        }
        Firestore.firestore()
            .collection("users").document(uid).collection("pets")
            .getDocuments { snapshot, _ in
                DispatchQueue.main.async {
                    isLoadingPets = false
                    self.pets = snapshot?.documents.compactMap { doc in
                        let d = doc.data()
                        return Pet(
                            id: UUID(),
                            name:     d["name"]     as? String ?? "",
                            species:  d["species"]  as? String ?? "",
                            breed:    d["breed"]    as? String ?? "",
                            birthday: d["birthday"] as? String ?? "",
                            gender:   d["gender"]   as? String ?? "",
                            imageURL: d["imageURL"] as? String
                        )
                    } ?? []
                }
            }
    }

    // MARK: - Firebase: Bookings

    func loadBookingsFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoadingBookings = false; return
        }

        isLoadingBookings = true
        upcomingBooking   = nil
        recentBookings    = []

        Firestore.firestore()
            .collection("bookings")
            .whereField("petOwnerId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    isLoadingBookings = false
                    if let error = error {
                        print("❌ Bookings error: \(error.localizedDescription)")
                        return
                    }

                    let all: [HomeBooking] = (snapshot?.documents ?? []).compactMap { doc in
                        let d  = doc.data()
                        let ts = d["createdAt"] as? Timestamp
                        return HomeBooking(
                            id:                  doc.documentID,
                            serviceName:         d["serviceName"]         as? String ?? "Service",
                            petName:             d["petName"]             as? String ?? "",
                            serviceProviderName: d["serviceProviderName"] as? String ?? "",
                            date:                d["date"]                as? String ?? "",
                            time:                d["time"]                as? String ?? "",
                            status:              d["status"]              as? String ?? "pending",
                            createdAt:           ts?.dateValue()          ?? Date()
                        )
                    }
                    .sorted { $0.createdAt > $1.createdAt }

                    self.upcomingBooking = all.first { $0.status == "pending" }
                    self.recentBookings  = Array(all.prefix(5))
                    print("✅ Loaded \(all.count) booking(s)")
                }
            }
    }

    // MARK: - Helpers

    func serviceIcon(for service: String) -> String {
        switch service {
        case "Dog Walking": return "figure.walk"
        case "Grooming":    return "scissors"
        case "Training":    return "person.fill.checkmark"
        case "Vet Visit":   return "cross.case.fill"
        default:            return "pawprint.fill"
        }
    }

    func statusColor(_ status: String) -> Color {
        switch status {
        case "confirmed": return .green
        case "completed": return Color(red: 0.6, green: 0.4, blue: 0.9)
        case "cancelled": return .red
        default:          return .orange
        }
    }
}

// MARK: - Private Supporting Views

private struct HomeActivityRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 22))
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 14, weight: .semibold))
                Text(subtitle).font(.system(size: 12)).foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

private struct HomeTabBarItem: View {
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

#Preview {
    PetOwnerHomeView()
}
