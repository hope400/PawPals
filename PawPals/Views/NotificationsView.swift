//
//  NotificationsView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notifications: [PawPalsNotification] = []
    @State private var isLoading: Bool = true
    
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
                    
                    Text("Notifications")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        markAllAsRead()
                    }) {
                        Text("Clear All")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    .padding(.trailing, 16)
                    .frame(width: 100, alignment: .trailing)
                }
                .frame(height: 50)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                .overlay(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Notifications List
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading notifications...")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                        Spacer()
                    }
                } else if notifications.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "bell.slash")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("No Notifications")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text("You're all caught up!")
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(notifications) { notification in
                                NotificationRow(notification: notification)
                                
                                if notification.id != notifications.last?.id {
                                    Divider()
                                        .padding(.leading, 76)
                                }
                            }
                            
                            Spacer()
                                .frame(height: 80)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadNotifications()
        }
    }
    
    // MARK: - Load Notifications
    func loadNotifications() {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }
        
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("notifications")
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .getDocuments { snapshot, error in
                isLoading = false
                
                if let error = error {
                    print("❌ Error loading notifications: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    notifications = []
                    return
                }
                
                notifications = documents.compactMap { doc -> PawPalsNotification? in
                    let data = doc.data()
                    let timestamp = data["createdAt"] as? Timestamp ?? Timestamp()
                    
                    return PawPalsNotification(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        message: data["message"] as? String ?? "",
                        type: data["type"] as? String ?? "info",
                        isRead: data["isRead"] as? Bool ?? false,
                        createdAt: timestamp.dateValue()
                    )
                }
                
                print("✅ Loaded \(notifications.count) notifications")
            }
    }
    
    // MARK: - Mark All as Read
    func markAllAsRead() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let batch = db.batch()
        
        for notification in notifications {
            let ref = db.collection("users").document(userId).collection("notifications").document(notification.id)
            batch.deleteDocument(ref)
        }
        
        batch.commit { error in
            if let error = error {
                print("❌ Error clearing notifications: \(error.localizedDescription)")
            } else {
                print("✅ All notifications cleared")
                notifications = []
            }
        }
    }
}

// MARK: - Notification Model
struct PawPalsNotification: Identifiable {
    let id: String
    let title: String
    let message: String
    let type: String // booking, payment, message, system
    let isRead: Bool
    let createdAt: Date
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: PawPalsNotification
    
    var icon: String {
        switch notification.type {
        case "booking": return "calendar"
        case "payment": return "creditcard"
        case "message": return "message"
        default: return "bell"
        }
    }
    
    var iconColor: Color {
        switch notification.type {
        case "booking": return Color(red: 0.6, green: 0.4, blue: 0.9)
        case "payment": return .green
        case "message": return .blue
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Circle()
                .fill(iconColor.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(notification.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Text(notification.message)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text(timeAgo(notification.createdAt))
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.7))
            }
            
            Spacer()
            
            // Unread badge
            if !notification.isRead {
                Circle()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(notification.isRead ? Color.clear : Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.02))
    }
    
    func timeAgo(_ date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        
        if days >= 1 {
            return "\(Int(days))d ago"
        } else if hours >= 1 {
            return "\(Int(hours))h ago"
        } else if minutes >= 1 {
            return "\(Int(minutes))m ago"
        } else {
            return "Just now"
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
