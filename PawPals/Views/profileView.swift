//
//  ProfileView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    @State private var fullName:        String = ""
    @State private var email:           String = ""
    @State private var phoneNumber:     String = ""
    @State private var bio:             String = ""
    @State private var userType:        String = ""
    @State private var memberSince:     String = ""
    @State private var profileImageUrl: String = ""
    @State private var isLoading:       Bool   = true
    @State private var petCount:        Int    = 0
    @State private var bookingCount:    Int    = 0

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.98)
                .ignoresSafeArea()

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

                        // ── Purple header banner ──────────────
                        ZStack(alignment: .bottom) {
                            // Background gradient
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.5, green: 0.3, blue: 0.85),
                                    Color(red: 0.65, green: 0.45, blue: 0.95)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(height: 200)

                            // Back button
                            VStack {
                                HStack {
                                    Button(action: { dismiss() }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 20, weight: .semibold))
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
                                    // Edit button placeholder
                                    NavigationLink(destination: EditProfileView()) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 18, weight: .semibold))
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

                            // Avatar — overlaps the banner
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 94, height: 94)

                                    if !profileImageUrl.isEmpty,
                                       let url = URL(string: profileImageUrl) {
                                        AsyncImage(url: url) { phase in
                                            if let img = phase.image {
                                                img.resizable()
                                                    .scaledToFill()
                                                    .frame(width: 86, height: 86)
                                                    .clipShape(Circle())
                                            } else {
                                                initialsAvatar
                                            }
                                        }
                                    } else {
                                        initialsAvatar
                                    }

                                    // Online dot
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 18, height: 18)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .offset(x: 32, y: 32)
                                }
                            }
                            .offset(y: 47)
                        }

                        // ── Name + type ───────────────────────
                        VStack(spacing: 6) {
                            Spacer().frame(height: 56) // space for avatar overlap

                            Text(fullName.isEmpty ? "PawPals User" : fullName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)

                            HStack(spacing: 6) {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                Text(formattedUserType)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 5)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .cornerRadius(20)

                            if !memberSince.isEmpty {
                                Text("Member since \(memberSince)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 20)

                        // ── Stats row ─────────────────────────
                        HStack(spacing: 0) {
                            ProfileStatCell(value: "\(petCount)",   label: "Pets")
                            Divider().frame(height: 40)
                            ProfileStatCell(value: "\(bookingCount)", label: "Bookings")
                            Divider().frame(height: 40)
                            ProfileStatCell(value: "⭐ 5.0",       label: "Rating")
                        }
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)

                        // ── Info section ──────────────────────
                        VStack(spacing: 14) {

                            // Bio
                            if !bio.isEmpty {
                                ProfileInfoCard(title: "About Me") {
                                    Text(bio)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }

                            // Contact info
                            ProfileInfoCard(title: "Contact Information") {
                                VStack(spacing: 12) {
                                    ProfileInfoRow(icon: "envelope.fill",
                                                   label: "Email",
                                                   value: email)
                                    if !phoneNumber.isEmpty {
                                        Divider()
                                        ProfileInfoRow(icon: "phone.fill",
                                                       label: "Phone",
                                                       value: phoneNumber)
                                    }
                                }
                            }

                            // Account info
                            ProfileInfoCard(title: "Account") {
                                VStack(spacing: 12) {
                                    ProfileInfoRow(icon: "person.fill",
                                                   label: "Account Type",
                                                   value: formattedUserType)
                                    if !memberSince.isEmpty {
                                        Divider()
                                        ProfileInfoRow(icon: "calendar",
                                                       label: "Member Since",
                                                       value: memberSince)
                                    }
                                }
                            }

                            // Sign out button
                            Button(action: { signOut() }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.right.square.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.red)
                                    Text("Sign Out")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.red)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13))
                                        .foregroundColor(.red.opacity(0.5))
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
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

    // ── Initials avatar ───────────────────────────────
    private var initialsAvatar: some View {
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
                .frame(width: 86, height: 86)
            Text(initials)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private var initials: String {
        let parts = fullName.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(fullName.prefix(2)).uppercased()
    }

    private var formattedUserType: String {
        switch userType {
        case "pet_owner", "petOwner": return "Pet Owner"
        case "serviceProvider":        return "Service Provider"
        case "businessClient":         return "Business Client"
        default:                       return userType.capitalized
        }
    }

    // MARK: - Firebase

    func loadProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false; return
        }

        let db = Firestore.firestore()

        // Load user document
        db.collection("users").document(uid).getDocument { snapshot, error in
            DispatchQueue.main.async {
                isLoading = false
                guard let d = snapshot?.data() else { return }

                self.fullName        = d["fullName"]        as? String ?? ""
                self.email           = d["email"]           as? String ?? Auth.auth().currentUser?.email ?? ""
                self.phoneNumber     = d["phoneNumber"]     as? String ?? ""
                self.bio             = d["bio"]             as? String ?? ""
                self.userType        = d["userType"]        as? String ?? ""
                self.profileImageUrl = d["profileImageUrl"] as? String ?? ""

                if let ts = d["createdAt"] as? Timestamp {
                    let formatter        = DateFormatter()
                    formatter.dateFormat = "MMM yyyy"
                    self.memberSince     = formatter.string(from: ts.dateValue())
                }
            }
        }

        // Count pets
        db.collection("users").document(uid).collection("pets")
            .getDocuments { snapshot, _ in
                DispatchQueue.main.async {
                    self.petCount = snapshot?.documents.count ?? 0
                }
            }

        // Count bookings
        db.collection("bookings")
            .whereField("petOwnerId", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                DispatchQueue.main.async {
                    self.bookingCount = snapshot?.documents.count ?? 0
                }
            }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }
}

// MARK: - Supporting Views

private struct ProfileStatCell: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileInfoCard<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title   = title
        self.content = content()
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

private struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
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

#Preview {
    ProfileView()
}
