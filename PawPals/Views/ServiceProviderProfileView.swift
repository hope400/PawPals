//
//  ServiceProviderProfileView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ServiceProviderProfileView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name:           String   = ""
    @State private var email:          String   = ""
    @State private var phone:          String   = ""
    @State private var bio:            String   = ""
    @State private var hourlyRate:     Double   = 0
    @State private var rating:         Double   = 0
    @State private var reviewCount:    Int      = 0
    @State private var completedJobs:  Int      = 0
    @State private var memberSince:    String   = ""
    @State private var services:       [String] = []
    @State private var imageURL:       String   = ""
    @State private var isLoading:      Bool     = true

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.98).ignoresSafeArea()

            if isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(
                            tint: Color(red: 0.6, green: 0.4, blue: 0.9)))
                        .scaleEffect(1.5)
                    Spacer()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // ── Purple banner ─────────────────────
                        ZStack(alignment: .bottom) {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.45, green: 0.25, blue: 0.80),
                                    Color(red: 0.65, green: 0.45, blue: 0.95)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(height: 200)

                            // Nav buttons
                            VStack {
                                HStack {
                                    Button(action: { dismiss() }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.white.opacity(0.2))
                                            .clipShape(Circle())
                                    }
                                    Spacer()
                                    Text("My Profile")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: { signOut() }) {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.white.opacity(0.2))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                Spacer()
                            }
                            .frame(height: 200)

                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 96, height: 96)

                                if !imageURL.isEmpty, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { phase in
                                        if let img = phase.image {
                                            img.resizable().scaledToFill()
                                                .frame(width: 88, height: 88)
                                                .clipShape(Circle())
                                        } else { initialsCircle }
                                    }
                                } else { initialsCircle }

                                // Verified badge
                                Circle()
                                    .fill(Color(red: 0.3, green: 0.7, blue: 0.4))
                                    .frame(width: 26, height: 26)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .offset(x: 34, y: 34)
                            }
                            .offset(y: 48)
                        }

                        // ── Name + rate ───────────────────────
                        VStack(spacing: 6) {
                            Spacer().frame(height: 58)

                            Text(name.isEmpty ? "Service Provider" : name)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)

                            HStack(spacing: 6) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                Text("$\(Int(hourlyRate))/hr")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            .padding(.horizontal, 14).padding(.vertical, 5)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .cornerRadius(20)

                            if !memberSince.isEmpty {
                                Text("Member since \(memberSince)")
                                    .font(.system(size: 12)).foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 20)

                        // ── Stats ─────────────────────────────
                        HStack(spacing: 0) {
                            SPProfileStat(value: String(format: "%.1f", rating), label: "Rating", icon: "star.fill", color: .orange)
                            Divider().frame(height: 40)
                            SPProfileStat(value: "\(completedJobs)", label: "Jobs Done", icon: "briefcase.fill", color: Color(red: 0.6, green: 0.4, blue: 0.9))
                            Divider().frame(height: 40)
                            SPProfileStat(value: "\(reviewCount)", label: "Reviews", icon: "person.2.fill", color: .green)
                        }
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)

                        VStack(spacing: 14) {

                            // Services offered
                            if !services.isEmpty {
                                SPInfoCard(title: "Services Offered") {
                                    FlowLayout(services: services)
                                }
                            }

                            // Bio
                            if !bio.isEmpty {
                                SPInfoCard(title: "About Me") {
                                    Text(bio)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }

                            // Contact
                            SPInfoCard(title: "Contact Information") {
                                VStack(spacing: 12) {
                                    SPInfoRow(icon: "envelope.fill", label: "Email", value: email)
                                    if !phone.isEmpty {
                                        Divider()
                                        SPInfoRow(icon: "phone.fill", label: "Phone", value: phone)
                                    }
                                }
                            }

                            // Performance
                            SPInfoCard(title: "Performance") {
                                VStack(spacing: 12) {
                                    SPInfoRow(icon: "star.fill",
                                              label: "Average Rating",
                                              value: String(format: "%.1f / 5.0", rating))
                                    Divider()
                                    SPInfoRow(icon: "checkmark.circle.fill",
                                              label: "Jobs Completed",
                                              value: "\(completedJobs)")
                                    Divider()
                                    SPInfoRow(icon: "person.2.fill",
                                              label: "Total Reviews",
                                              value: "\(reviewCount)")
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { loadProfile() }
    }

    // ── Initials circle ───────────────────────────────
    private var initialsCircle: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.4, blue: 0.9),
                        Color(red: 0.65, green: 0.5, blue: 0.95)
                    ]),
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .frame(width: 88, height: 88)
            Text(String(name.prefix(1)).uppercased())
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
        }
    }

    // MARK: - Firebase
    func loadProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false; return
        }
        Firestore.firestore()
            .collection("serviceProviders").document(uid)
            .getDocument { snapshot, _ in
                DispatchQueue.main.async {
                    isLoading = false
                    guard let d = snapshot?.data() else { return }
                    self.name          = d["name"]          as? String   ?? ""
                    self.email         = d["email"]         as? String   ?? Auth.auth().currentUser?.email ?? ""
                    self.phone         = d["phone"]         as? String   ?? ""
                    self.bio           = d["bio"]           as? String   ?? ""
                    self.hourlyRate    = d["hourlyRate"]    as? Double   ?? 0
                    self.rating        = d["rating"]        as? Double   ?? 0
                    self.reviewCount   = d["reviewCount"]   as? Int      ?? 0
                    self.completedJobs = d["completedJobs"] as? Int      ?? 0
                    self.memberSince   = d["memberSince"]   as? String   ?? ""
                    self.services      = d["services"]      as? [String] ?? []
                    self.imageURL      = d["imageURL"]      as? String   ?? ""
                }
            }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }
}

// MARK: - Supporting Views

private struct SPProfileStat: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SPInfoCard<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title; self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            content
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

private struct SPInfoRow: View {
    let icon: String
    let label: String
    let value: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                .frame(width: 20)
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
        }
    }
}

private struct FlowLayout: View {
    let services: [String]
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
            ForEach(services, id: \.self) { service in
                HStack(spacing: 6) {
                    Image(systemName: serviceIcon(service))
                        .font(.system(size: 12))
                    Text(service)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1)
                )
            }
        }
    }

    func serviceIcon(_ service: String) -> String {
        switch service {
        case "Dog Walking": return "figure.walk"
        case "Pet Sitting": return "house.fill"
        case "Grooming":    return "scissors"
        case "Training":    return "person.fill.checkmark"
        case "Vet Visit":   return "cross.case.fill"
        default:            return "pawprint.fill"
        }
    }
}

#Preview {
    ServiceProviderProfileView()
}
